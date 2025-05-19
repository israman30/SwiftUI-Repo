import UIKit
import SwiftUI

/**
 `In Swift, both async let and TaskGroup are used to perform concurrent asynchronous tasks, but they serve different purposes and have distinct characteristics. Below, I’ll explain the differences between async let and TaskGroup, including their use cases, syntax, and behavior, with examples tailored to the context of your previous question about image picking and rendering in SwiftUI.
 
 `1. async let
 Overview:
 - async let is a concise syntax for launching asynchronous tasks concurrently within an async context.
 - It allows you to define and await multiple asynchronous operations in a straightforward way, with the results automatically resolved when you await them.
 - It is best suited for a fixed, small number of known asynchronous tasks that you want to run concurrently.
 */

func someAsyncFunction1() async throws -> Int {
    sleep(2)
    return 1
}

func someAsyncFunction2() async throws -> Int {
    sleep(2)
    return 1
}

async let value1 = someAsyncFunction1()
async let value2 = someAsyncFunction2()
let result = try await [value1, value2]

// Suppose you want to load two images concurrently from URLs in your SwiftUI app:

func loadImage(from url: URL) async throws -> UIImage {
    let (data, _) = try await URLSession.shared.data(from: url)
    guard let image = UIImage(data: data) else {
        throw URLError(.badServerResponse)
    }
    return image
}

struct ContentView: View {
    @State private var images: [UIImage] = []
    
    var body: some View {
        VStack {
            ForEach(images, id: \.self) { image in
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 100)
            }
            Button("Load Images") {
                Task {
                    do {
                        async let image1 = loadImage(from: URL(string: "https://example.com/image1.jpg")!)
                        async let image2 = loadImage(from: URL(string: "https://example.com/image2.jpg")!)
                        images = try await [image1, image2]
                    } catch {
                        print("Error: \(error)")
                    }
                }
            }
        }
    }
}

/**
 `2. TaskGroup
 Overview:
 - TaskGroup (or withTaskGroup) is a more flexible and powerful API for managing a dynamic group of concurrent asynchronous tasks.
 - It allows you to create, manage, and collect results from a variable number of tasks, making it suitable for scenarios where the number of tasks is determined at runtime.
 - It is ideal for dynamic, iterative, or complex concurrency scenarios.
 */
struct ResultType {
    
}

let items: [Int] = [1, 2, 3, 4, 5]

func someAsyncFunction(_ int: Int) { sleep(1) }

await withTaskGroup(of: ResultType.self) { group in
    for item in items {
        group.addTask {
            return await someAsyncFunction(item)
        }
    }
    var results: [ResultType] = []
    for await result in group {
        results.append(result)
    }
    return results
}

// Just sample like async let
func loadImage(from url: URL) async throws -> UIImage {
    let (data, _) = try await URLSession.shared.data(from: url)
    guard let image = UIImage(data: data) else {
        throw URLError(.badServerResponse)
    }
    return image
}

struct ContentView: View {
    @State private var images: [UIImage] = []
    let imageURLs = [
        URL(string: "https://example.com/image1.jpg")!,
        URL(string: "https://example.com/image2.jpg")!,
        URL(string: "https://example.com/image3.jpg")!
    ]
    
    var body: some View {
        VStack {
            ForEach(images, id: \.self) { image in
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 100)
            }
            Button("Load Images") {
                Task {
                    do {
                        images = try await withTaskGroup(of: UIImage.self) { group in
                            for url in imageURLs {
                                group.addTask {
                                    do {
                                        return try await loadImage(from: url)
                                    } catch {
                                        print("Failed to load image from \(url): \(error)")
                                        return UIImage() // Fallback or handle error
                                    }
                                }
                            }
                            var loadedImages: [UIImage] = []
                            for await image in group {
                                if !image.size.equalTo(.zero) { // Skip failed images
                                    loadedImages.append(image)
                                }
                            }
                            return loadedImages
                        }
                    } catch {
                        print("Task group error: \(error)")
                    }
                }
            }
        }
    }
}

/**
 `1. Use async let:
 - If you have a fixed number of images to process (e.g., always loading exactly two thumbnails for a preview).
 - Example: Loading a primary and secondary image for a gallery item concurrently.
 - In your image picker scenario, async let could be used if you’re processing a small, fixed set of selected images (e.g., resizing two images):
 
 `2. Use TaskGroup:

 - If the number of images is dynamic (e.g., the user selects 1 to 100 images in the PHPickerViewController).
 - Example: Processing all selected images (e.g., resizing, uploading, or converting) in parallel.
 - In your image picker scenario, TaskGroup is ideal for handling multiple images selected via PHPickerViewController:
 */
