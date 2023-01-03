//
//  ArticleInfo.swift
//  NEWStream
//
//  Created by Aliaksandr Sukhadolau on 26.12.22.
//

import Foundation

struct ArticlesResponse: Codable {
    let articles: [ArticleInfo]
    
    enum CodingKeys: String, CodingKey {
        case articles = "articles"
    }
}

public struct ArticleInfo: Codable, Identifiable {
    public var id = UUID()
    public let title: String
    public let description: String?
    public let content: String?
    public let imageUrlString: String?
    public let sourceUrlString: String?
    
    enum CodingKeys: String, CodingKey {
        case title = "title"
        case description = "description"
        case content = "content"
        case imageUrlString = "urlToImage"
        case sourceUrlString = "url"
    }
}
