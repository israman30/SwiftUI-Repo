//
//  NetworkManager.swift
//  Express
//
//  Created by Israel Manzo on 4/17/25.
//

import Foundation

struct Endpoint {
    static let baseURL = "https://localhost:3000/"
    static let uiList = "ui-list"
}

class NetworkManager {
    func fetchData(urlString: String) async throws -> Template {
        let (data, response) = try await URLSession.shared.data(from: URL(string: urlString)!)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            fatalError("Status code is not 200")
        }
        
        return try JSONDecoder().decode(Template.self, from: data)
    }
}
