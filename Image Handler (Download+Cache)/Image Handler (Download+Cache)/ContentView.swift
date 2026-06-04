//
//  ContentView.swift
//  Image Handler (Download+Cache)
//
//  Created by Israel Manzo on 6/4/26.
//

import SwiftUI

struct ContentView: View {
    private let sampleURLs: [URL] = [
        URL(string: "https://picsum.photos/id/237/600/600")!,
        URL(string: "https://picsum.photos/id/1003/600/600")!,
        URL(string: "https://picsum.photos/id/1025/600/600")!,
        URL(string: "https://picsum.photos/id/1069/600/600")!
    ]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(sampleURLs, id: \.self) { url in
                        CachedRemoteImage(url: url, contentMode: .fill) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 16, style: .continuous)
                                    .fill(.gray.opacity(0.15))
                                ProgressView()
                            }
                        }
                        .frame(height: 220)
                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                    }
                }
                .padding()
            }
            .navigationTitle("Image Cache")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Clear") {
                        Task { await ImageCacheStore.shared.clear() }
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
