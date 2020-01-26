//
//  ApiEndPointsEnums.swift
//  Jornaly
//
//  Created by MacBookPro on 1/20/20.
//  Copyright © 2020 MacBookPro. All rights reserved.
//

import Foundation

enum Endpoints{
    case countryHeadlines
    case categoryHeadlines
    case searchEverything(String)
    
    var stringValue: String{
        switch self {
        
        case .countryHeadlines:
            return NewsData.headlines + "country=\(NewsData.countryName)"
        
        case .categoryHeadlines:
            return NewsData.headlines + "country=\(NewsData.countryName)&category=\(NewsData.categoryName)"
        
        case .searchEverything(let query):
            return NewsData.everything + "q=\(query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")&sortBy=popularity&pageSize=20&page=\(NewsData.searchPage)"
        }
    }
    var url: URL {
        return URL(string: stringValue)!
    }
    
}
