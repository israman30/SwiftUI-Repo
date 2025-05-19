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
