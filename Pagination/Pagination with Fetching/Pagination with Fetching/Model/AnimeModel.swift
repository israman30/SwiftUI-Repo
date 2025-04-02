//
//  AnimeModel.swift
//  Pagination with Fetching
//
//  Created by Israel Manzo on 4/2/25.
//

import Foundation

// Model
struct JikanMoeResponse: Decodable, Equatable {
    let pagination: Pagination
    let data: [Anime]
}

struct Pagination: Decodable, Equatable {
    let lastVisiblePage: Int
    let hasNextPage: Bool
    let currentPage: Int
    
    enum CodingKeys: String, CodingKey {
        case lastVisiblePage = "last_visible_page"
        case hasNextPage = "has_next_page"
        case currentPage = "current_page"
    }
}

struct Anime: Identifiable, Decodable, Equatable {
    var id: Int
    let url: String
    let image: AnimeImages
    let title: String
    let episodes: Int?
    let rank: Int?
    let score: Double?
    
    enum CodingKeys: String, CodingKey {
        case id = "mal_id"
        case url = "url"
        case image = "images"
        case title = "title"
        case episodes = "episodes"
        case rank = "rank"
        case score = "score"
    }
}

struct AnimeImages: Decodable, Equatable {
    let jpg: ImageDetails
    let webp: ImageDetails
}

struct ImageDetails: Decodable, Equatable {
    let imageUrl: String
    let smallImageUrl: String
    let largeImageUrl: String
    
    enum CodingKeys: String, CodingKey {
        case imageUrl = "image_url"
        case smallImageUrl = "small_image_url"
        case largeImageUrl = "large_image_url"
    }
}

