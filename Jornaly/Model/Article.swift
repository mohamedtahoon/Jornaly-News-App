//
//  Article.swift
//  Jornaly
//
//  Created by MacBookPro on 1/20/20.
//  Copyright © 2020 MacBookPro. All rights reserved.
//

import Foundation

struct Article: Codable {
    let source: Source
    let author: String?
    let title: String
    let description: String?
    let url: String
    let urlToImage: String?
    let publishedAt: String
    let content: String?
}

struct Source: Codable {
    let id: String?
    let name: String
}

struct NewsResponse: Codable {
    let totalResults: Int
    let articles: [Article]
}

struct ErrorResponse: Codable {
    let message: String
}
