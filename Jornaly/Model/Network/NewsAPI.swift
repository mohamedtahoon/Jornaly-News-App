//
//  NewsAPI.swift
//  Jornaly
//
//  Created by MacBookPro on 1/20/20.
//  Copyright © 2020 MacBookPro. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper


class NewsAPI{
    
    class func getHeadlineNews(countryName: [String], categoryName: String , completion: @escaping ([Article], String, Error?)-> Void) {
        NewsData.countryName = countryName[0]
        NewsData.categoryName = categoryName
        let newsUrl = (categoryName == "HeadLines") ? Endpoints.countryHeadlines.url : Endpoints.categoryHeadlines.url
        
        getNewsFromApi(countryName: countryName, url: newsUrl, responseType: NewsResponse.self, completion: {(response, errorMessage, error)
            in
            guard let response = response else{
                completion([], errorMessage, error)
                return
            }
            
            completion(response.articles, countryName[1], nil)
        })
    }
    
    class func getSearchInEveryThingNews(keyword:String , completionHandler: @escaping ([Article], String, Error?)-> Void) {
        
        getNewsFromApi(countryName: [""], url: Endpoints.searchEverything(keyword).url, responseType: NewsResponse.self, completion: {(response, errorMessage, error) in
            
            guard let response = response else{
                completionHandler([], errorMessage, error)
                return
            }
            
            NewsData.totalPages = response.totalResults / 20
            completionHandler(response.articles, "", nil)
        })
    }
    
    class func getNewsFromApi <Response: Decodable> (countryName: [String], url: URL, responseType: Response.Type, completion: @escaping (Response?, String, Error?)-> Void) {
        NewsData.countryName = countryName[0]
        let url = URL(string: "\(url)&apiKey=\(NewsData.apiKey)")
        
        Alamofire.request(url!, method: .get).responseData { (myResponse) in
            
            switch myResponse.result{
                
            case .success:
                do {
                    let responseJson = try JSONDecoder().decode(Response.self, from: myResponse.data!)
                    DispatchQueue.main.async {
                        completion(responseJson, "", nil)
                    }
                }
                catch {
                    do {
                        let errorResponse = try JSONDecoder().decode(ErrorResponse.self, from: myResponse.data!)
                        DispatchQueue.main.async {
                            completion(nil, errorResponse.message, error)
                        }
                    }
                    catch {
                        DispatchQueue.main.async {
                            completion(nil, "", error)
                        }
                    }
                }
                
            case .failure:
                print("Error, could not get response from API")
            }
        }
    }
}
