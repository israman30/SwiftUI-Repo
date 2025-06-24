//
//  APIKey.swift
//  Implementing Gemini
//
//  Created by Israel Manzo on 6/24/25.
//

import Foundation

enum APIKey {
    static var key: String {
        guard let filePath = Bundle.main.path(forResource: "Generate-Ai", ofType: "plist") else {
            fatalError("No name related to [Generate-Ai.plist]")
        }
        let plist = NSDictionary(contentsOfFile: filePath)!
        guard let value = plist.object(forKey: "API_KEY") as? String else {
            fatalError("Value from API_KEY does not exist")
        }
        if value.starts(with: "_") {
            fatalError("Go to https://ai.google.dev/tutorials/setup to get a valid API key")
        }
        return value
    }
}
