//
//  Image_Handler__Download_Cache_Tests.swift
//  Image Handler (Download+Cache)Tests
//
//  Created by Israel Manzo on 6/4/26.
//

import XCTest
import Foundation
@testable import Image_Handler__Download_Cache_

final class Image_Handler__Download_Cache_Tests: XCTestCase {
    func testCache_insertThenFetch_returnsImage() async {
        let cache = ImageCacheStore(directoryName: "ImageCacheStore-tests-\(UUID().uuidString)")
        let url = URL(string: "https://example.com/image.png")!
        let data = TestAssets.oneByOnePNG
        
        await cache.insert(data, for: url)
        let fetched = await cache.image(for: url)
        
        XCTAssertNotNil(fetched)
    }
    
    func testCache_remove_removesImage() async {
        let cache = ImageCacheStore(directoryName: "ImageCacheStore-tests-\(UUID().uuidString)")
        let url = URL(string: "https://example.com/image.png")!
        let data = TestAssets.oneByOnePNG
        
        await cache.insert(data, for: url)
        await cache.remove(for: url)
        
        let fetched = await cache.image(for: url)
        XCTAssertNil(fetched)
    }
    
    func testCache_clear_removesAllImages() async {
        let cache = ImageCacheStore(directoryName: "ImageCacheStore-tests-\(UUID().uuidString)")
        let urls = [
            URL(string: "https://example.com/a.png")!,
            URL(string: "https://example.com/b.png")!,
            URL(string: "https://example.com/c.png")!
        ]
        
        for url in urls {
            await cache.insert(TestAssets.oneByOnePNG, for: url)
        }
        
        await cache.clear()
        
        for url in urls {
            let fetched = await cache.image(for: url)
            XCTAssertNil(fetched)
        }
    }
    
    func testDownloader_usesCacheOnSecondRequest() async throws {
        let url = URL(string: "https://example.com/image.png")!
        
        let cache = ImageCacheStore(directoryName: "ImageCacheStore-tests-\(UUID().uuidString)")
        let session = TestURLSessionFactory.makeSession { request in
            XCTAssertEqual(request.url, url)
            return .success(statusCode: 200, data: TestAssets.oneByOnePNG)
        }
        let downloader = ImageDownloader(cache: cache, session: session)
        
        MockURLProtocol.reset()
        
        _ = try await downloader.image(from: url)
        _ = try await downloader.image(from: url)
        
        XCTAssertEqual(MockURLProtocol.requestCount, 1, "Second request should be served from cache.")
    }
    
    func testDownloader_coalescesInFlightRequests() async throws {
        let url = URL(string: "https://example.com/image.png")!
        
        let cache = ImageCacheStore(directoryName: "ImageCacheStore-tests-\(UUID().uuidString)")
        let session = TestURLSessionFactory.makeSession { _ in
            .success(statusCode: 200, data: TestAssets.oneByOnePNG, delayNanoseconds: 250_000_000)
        }
        let downloader = ImageDownloader(cache: cache, session: session)
        
        MockURLProtocol.reset()
        
        async let first = downloader.image(from: url)
        async let second = downloader.image(from: url)
        _ = try await (first, second)
        
        XCTAssertEqual(MockURLProtocol.requestCount, 1, "Concurrent requests for the same URL should share one download task.")
    }
    
    func testDownloader_badStatusCode_throws() async {
        let url = URL(string: "https://example.com/image.png")!
        
        let cache = ImageCacheStore(directoryName: "ImageCacheStore-tests-\(UUID().uuidString)")
        let session = TestURLSessionFactory.makeSession { _ in
            .success(statusCode: 500, data: Data())
        }
        let downloader = ImageDownloader(cache: cache, session: session)
        
        do {
            _ = try await downloader.image(from: url)
            XCTFail("Expected to throw.")
        } catch let error as ImageDownloadError {
            guard case .badStatusCode(500) = error else {
                return XCTFail("Unexpected error: \(error)")
            }
        } catch {
            XCTFail("Unexpected error type: \(error)")
        }
    }
}

private enum TestAssets {
    /// A valid 1x1 PNG.
    static let oneByOnePNG: Data = Data(base64Encoded:
        "iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mP8/xcAAgMBgN2N8o0AAAAASUVORK5CYII="
    )!
}

private enum TestURLSessionFactory {
    static func makeSession(_ handler: @escaping (URLRequest) throws -> MockURLProtocol.MockResponse) -> URLSession {
        MockURLProtocol.handler = handler
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        return URLSession(configuration: config)
    }
}

private final class MockURLProtocol: URLProtocol {
    struct MockResponse {
        let statusCode: Int
        let data: Data
        let delayNanoseconds: UInt64
    }
    
    static var handler: ((URLRequest) throws -> MockResponse)?
    
    private static let lock = NSLock()
    private(set) static var requestCount: Int = 0
    
    static func reset() {
        lock.lock()
        requestCount = 0
        lock.unlock()
    }
    
    override class func canInit(with request: URLRequest) -> Bool { true }
    override class func canonicalRequest(for request: URLRequest) -> URLRequest { request }
    
    override func startLoading() {
        Self.lock.lock()
        Self.requestCount += 1
        Self.lock.unlock()
        
        guard let handler = Self.handler else {
            client?.urlProtocol(self, didFailWithError: URLError(.badServerResponse))
            return
        }
        
        do {
            let mock = try handler(request)
            let url = request.url ?? URL(string: "https://example.com")!
            let response = HTTPURLResponse(url: url, statusCode: mock.statusCode, httpVersion: "HTTP/1.1", headerFields: nil)!
            
            let send: () -> Void = { [weak self] in
                guard let self else { return }
                self.client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
                self.client?.urlProtocol(self, didLoad: mock.data)
                self.client?.urlProtocolDidFinishLoading(self)
            }
            
            if mock.delayNanoseconds > 0 {
                DispatchQueue.global().asyncAfter(deadline: .now() + .nanoseconds(Int(mock.delayNanoseconds))) {
                    send()
                }
            } else {
                send()
            }
        } catch {
            client?.urlProtocol(self, didFailWithError: error)
        }
    }
    
    override func stopLoading() {
        // No-op: requests are fully controlled by this protocol.
    }
}

private extension MockURLProtocol.MockResponse {
    static func success(statusCode: Int, data: Data, delayNanoseconds: UInt64 = 0) -> Self {
        .init(statusCode: statusCode, data: data, delayNanoseconds: delayNanoseconds)
    }
}
