//
//  ContentView.swift
//  Pagination-B
//
//  Created by Israel Manzo on 11/10/23.
//

import SwiftUI

struct ContentView: View {
    @StateObject var vm: ViewModel
    
    init() {
        self._vm = StateObject(wrappedValue: ViewModel(network: NetworkServices()))
    }
    
    var body: some View {
        NavigationView {
            List(vm.articles) { article in
                CardView(article: article)
                    .onAppear {
                        Task(priority: .high) {
                            await vm.loadContent(article: article)
                        }
                    }
            }
            .task {
                await vm.loadComments()
            }
        }
    }
}

#Preview {
    ContentView()
}

struct CardView: View {
    var article: Articles
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(article.author ?? "No author")
                .foregroundStyle(.gray)
            Text(article.title ?? "No title")
                .font(.body)
                .fontWeight(.bold)
            Text(article.description ?? "")
            HStack {
                Spacer()
                Text(article.publishedAt ?? "")
                    .foregroundStyle(.gray)
            }
        }
    }
}

struct ArticlesList: Decodable {
    let articles: [Articles]
}

struct Articles: Codable, Identifiable {
    var id = UUID().uuidString
    let author: String?
    let title: String?
    let description: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: String?
    
    enum CodingKeys: String, CodingKey {
        case author
        case title
        case description
        case url
        case urlToImage
        case publishedAt
    }
}

class NetworkServices {
    
    func getArticles(page: Int) async throws -> [Articles] {
        guard let url = URL(string: "https://newsapi.org/v2/top-headlines?country=us&apiKey=219d19ee586b4a049fafb28d3ecb7707&page=\(page)") else {
            fatalError("Wrong url")
        }
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse,
              (200...300).contains(response.statusCode) else {
            fatalError("Bad response \(response.description)")
        }
        
        return try JSONDecoder().decode(ArticlesList.self, from: data).articles
    }
}

@MainActor
class ViewModel: ObservableObject {
    private var network = NetworkServices()
    @Published var articles = [Articles]()
    
    private var totalPages = 0
    private var page = 1
    
    init(network: NetworkServices) {
        self.network = network
    }
    
    func loadComments() async {
        do {
            self.articles = try await network.getArticles(page: page)
        } catch {
            print("Error loading comments")
        }
    }
    
    func loadContent(article: Articles) async {
        print("paging")
        let index = self.articles.index(self.articles.endIndex, offsetBy: -1)
        if index == Int(article.id), (page + 1) <= totalPages {
            page += 1
            await loadComments()
        }
    }
}
