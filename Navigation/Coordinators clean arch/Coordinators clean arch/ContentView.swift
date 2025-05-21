//
//  ContentView.swift
//  Coordinators clean arch
//
//  Created by Israel Manzo on 5/21/25.
//

import SwiftUI

struct Article: Identifiable {
    var id: String {
        UUID().uuidString
    }
    
    let title: String
}

enum ViewState {
    case loading, loaded
    case error
}

enum ArticleListViewActions {
    case didTapOnArticle(_ article: Article)
    case didAppear
}

class ArticleListRouter {
    var moveToArticleDetail: ((Article) -> Void)?
}

class MyViewModel: ObservableObject {
    @Published var viewState: ViewState = .loading
    @Published var articles: [Article] = []
    @Published var showErrorAlert: Bool = false
    private var router: ArticleListRouter?
    
    func perform(action: ArticleListViewActions) {
        switch action {
        case .didTapOnArticle(let article):
            router?.moveToArticleDetail?(article)
        case .didAppear:
            return
        }
    }
}

struct ContentView: View {
    @ObservedObject var viewModel: MyViewModel
    
    var body: some View {
        List(viewModel.articles, id: \.id) { article in
            ArticleCell(article: article)
                .listRowSeparator(.hidden)
                .onTapGesture {
                    viewModel.perform(action: .didTapOnArticle(article))
                }
        }
        .listStyle(.plain)
        .overlay(content: {
            if viewModel.viewState == .loading {
                ProgressView()
            }
        })
        .onAppear(perform: {
            viewModel.perform(action: .didAppear)
        })
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    ContentView(viewModel: MyViewModel())
}

struct ArticleCell: View {
    var article: Article
    var body: some View {
        Text(article.title)
    }
}
