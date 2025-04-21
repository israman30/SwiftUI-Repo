//
//  NetworkManager.swift
//  Express
//
//  Created by Israel Manzo on 4/17/25.
// http://localhost:3000/ui-list

import Foundation

enum ErrorNetwork: Error {
    case errorResponse
}

struct Endpoint {
    static let baseURL = "http://localhost:3000/"
    static let uiList = "/ui-list"
}

class NetworkManager {
    func fetchData(urlString: String) async throws -> Template {
        let (data, response) = try await URLSession.shared.data(from: URL(string: urlString)!)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw ErrorNetwork.errorResponse
        }
        
        return try JSONDecoder().decode(Template.self, from: data)
    }
}

@MainActor
class UIListViewModel: ObservableObject {
    private let networkManager: NetworkManager
    @Published var compoennts: [UIComponent] = []
    
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }
    
    func fetchUIList() async {
        do {
            let template = try await networkManager.fetchData(urlString: Endpoint.baseURL + Endpoint.uiList)
            compoennts = try template.buildComponents()
        } catch {
            print("Error fetching data: \(error)")
        }
    }
}
