//
//  ImageCache.swift
//  Image Handler (Download+Cache)
//
//  Created by Israel Manzo on 6/4/26.
//

import SwiftUI
import Foundation
import Combine

#if canImport(UIKit)
import UIKit
public typealias PlatformImage = UIImage
#elseif canImport(AppKit)
import AppKit
public typealias PlatformImage = NSImage
#endif

import CryptoKit

public actor ImageCacheStore {
    public static let shared = ImageCacheStore()
    
    private let memoryCache = NSCache<NSString, PlatformImage>()
    private let fileManager = FileManager.default
    private let directoryURL: URL
    
    public init(
        directoryName: String = "ImageCacheStore",
        memoryCountLimit: Int = 200,
        memoryTotalCostLimitBytes: Int = 150 * 1024 * 1024
    ) {
        self.directoryURL = fileManager
            .urls(for: .cachesDirectory, in: .userDomainMask)[0]
            .appendingPathComponent(directoryName, isDirectory: true)
        
        memoryCache.countLimit = memoryCountLimit
        memoryCache.totalCostLimit = memoryTotalCostLimitBytes
        
        try? fileManager.createDirectory(at: directoryURL, withIntermediateDirectories: true, attributes: nil)
    }
    
    public func image(for url: URL) -> PlatformImage? {
        let key = url.absoluteString as NSString
        if let image = memoryCache.object(forKey: key) {
            return image
        }
        
        let fileURL = diskFileURL(for: url)
        guard let data = try? Data(contentsOf: fileURL),
              let image = PlatformImage(data: data) else {
            return nil
        }
        
        memoryCache.setObject(image, forKey: key, cost: data.count)
        return image
    }
    
    public func insert(_ data: Data, for url: URL) {
        let key = url.absoluteString as NSString
        if let image = PlatformImage(data: data) {
            memoryCache.setObject(image, forKey: key, cost: data.count)
        }
        
        let fileURL = diskFileURL(for: url)
        do {
            try data.write(to: fileURL, options: [.atomic])
        } catch {
            // Best-effort disk cache.
        }
    }
    
    public func remove(for url: URL) {
        let key = url.absoluteString as NSString
        memoryCache.removeObject(forKey: key)
        
        let fileURL = diskFileURL(for: url)
        try? fileManager.removeItem(at: fileURL)
    }
    
    public func clear() {
        memoryCache.removeAllObjects()
        try? fileManager.removeItem(at: directoryURL)
        try? fileManager.createDirectory(at: directoryURL, withIntermediateDirectories: true, attributes: nil)
    }
    
    private func diskFileURL(for url: URL) -> URL {
        directoryURL.appendingPathComponent(Self.cacheFilename(for: url.absoluteString), isDirectory: false)
    }
    
    private static func cacheFilename(for key: String) -> String {
        let digest = SHA256.hash(data: Data(key.utf8))
        return digest.map { String(format: "%02x", $0) }.joined()
    }
}

public enum ImageDownloadError: Error, LocalizedError {
    case nonHTTPResponse
    case badStatusCode(Int)
    case invalidImageData
    
    public var errorDescription: String? {
        switch self {
        case .nonHTTPResponse:
            return "Non-HTTP response."
        case .badStatusCode(let code):
            return "Bad status code: \(code)."
        case .invalidImageData:
            return "Invalid image data."
        }
    }
}

public actor ImageDownloader {
    public static let shared = ImageDownloader(cache: .shared)
    
    private let cache: ImageCacheStore
    private let session: URLSession
    private var inFlight: [URL: Task<PlatformImage, Error>] = [:]
    
    public init(cache: ImageCacheStore, session: URLSession = .shared) {
        self.cache = cache
        self.session = session
    }
    
    public func image(from url: URL) async throws -> PlatformImage {
        if let cached = await cache.image(for: url) {
            return cached
        }
        
        if let task = inFlight[url] {
            return try await task.value
        }
        
        let task = Task<PlatformImage, Error> {
            let (data, response) = try await session.data(from: url)
            
            guard let http = response as? HTTPURLResponse else {
                throw ImageDownloadError.nonHTTPResponse
            }
            guard (200..<300).contains(http.statusCode) else {
                throw ImageDownloadError.badStatusCode(http.statusCode)
            }
            guard let image = PlatformImage(data: data) else {
                throw ImageDownloadError.invalidImageData
            }
            
            await cache.insert(data, for: url)
            return image
        }
        
        inFlight[url] = task
        do {
            let image = try await task.value
            inFlight[url] = nil
            return image
        } catch {
            inFlight[url] = nil
            throw error
        }
    }
}

@MainActor
public final class CachedRemoteImageModel: ObservableObject {
    @Published public private(set) var image: PlatformImage?
    @Published public private(set) var isLoading = false
    @Published public private(set) var error: Error?
    
    private let downloader: ImageDownloader
    private var task: Task<Void, Never>?
    
    public init(downloader: ImageDownloader = .shared) {
        self.downloader = downloader
    }
    
    public func load(from url: URL?) {
        task?.cancel()
        image = nil
        error = nil
        
        guard let url else { return }
        
        isLoading = true
        task = Task { [downloader] in
            do {
                let fetched = try await downloader.image(from: url)
                guard !Task.isCancelled else { return }
                await MainActor.run {
                    self.image = fetched
                    self.isLoading = false
                }
            } catch {
                guard !Task.isCancelled else { return }
                await MainActor.run {
                    self.error = error
                    self.isLoading = false
                }
            }
        }
    }
    
    public func cancel() {
        task?.cancel()
        task = nil
        isLoading = false
    }
}

public struct CachedRemoteImage<Placeholder: View>: View {
    private let url: URL?
    private let contentMode: ContentMode
    private let placeholder: () -> Placeholder
    
    @StateObject private var model: CachedRemoteImageModel
    
    public init(
        url: URL?,
        contentMode: ContentMode = .fill,
        downloader: ImageDownloader = .shared,
        @ViewBuilder placeholder: @escaping () -> Placeholder
    ) {
        self.url = url
        self.contentMode = contentMode
        self.placeholder = placeholder
        _model = StateObject(wrappedValue: CachedRemoteImageModel(downloader: downloader))
    }
    
    public var body: some View {
        ZStack {
            if let image = model.image {
                Image(platformImage: image)
                    .resizable()
                    .aspectRatio(contentMode: contentMode)
            } else {
                placeholder()
            }
        }
        .task(id: url) {
            model.load(from: url)
        }
        .onDisappear {
            model.cancel()
        }
    }
}

private extension Image {
    init(platformImage: PlatformImage) {
        #if canImport(UIKit)
        self.init(uiImage: platformImage)
        #elseif canImport(AppKit)
        self.init(nsImage: platformImage)
        #endif
    }
}

// Intentionally no PlatformImage sizing helpers here.

