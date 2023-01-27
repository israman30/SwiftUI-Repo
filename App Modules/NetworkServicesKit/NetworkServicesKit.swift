//
//  NetworkServicesKit.swift
//  NetworkServicesKit
//
//  Created by Israel Manzo on 1/26/23.
//

import Foundation

public class NetworkServicesKitImplementation {
    public init() {}
    public func get<T: Decodable>(url: URL) async throws -> T {
        let (data, _ ) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode(T.self, from: data)
    }
}
