//
//  NewsData.swift
//  Jornaly
//
//  Created by MacBookPro on 1/20/20.
//  Copyright © 2020 MacBookPro. All rights reserved.
//

import Foundation

struct NewsData {
    static let apiKey = "db358b36376b40528bac16f119610dd9"
    static let headlines = "https://newsapi.org/v2/top-headlines?"
    static let everything = "https://newsapi.org/v2/everything?"
    
    static var countryName = ""
    static var categoryName = ""
    static var totalPages = 0
    static var searchPage = 1
}
