//
//  SearchForAnythingVC.swift
//  Jornaly
//
//  Created by MacBookPro on 1/20/20.
//  Copyright © 2020 MacBookPro. All rights reserved.
//

import UIKit

class SearchForAnythingVC: UIViewController, UISearchBarDelegate, UICollectionViewDataSource {
    
    
    @IBOutlet weak var searchCollectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var articles = [Article]()
    var search = ""
    var isLoading = false
    
    //MARK: View did load
    override func viewDidLoad() {
        super.viewDidLoad()
        searchCollectionView.delegate = self
        searchCollectionView.dataSource = self
    }
    
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.showsCancelButton = false
        self.articles.removeAll()
        searchCollectionView.reloadData()
        if let searchKeyword = searchBar.text {
            NewsData.searchPage = 1
            self.search = searchKeyword
            NewsAPI.getSearchInEveryThingNews(keyword: search, completionHandler: handleNewsSearchResponse(articles:countryName:error:))
        }
    }
    
    
    
    func handleNewsSearchResponse(articles: [Article] ,countryName: String, error: Error?) {
        if error != nil  {
            return
        }
        
        if articles.count == 0 {
            let alert = UIAlertController(title: "Sorry", message: "No Articles Found for \(String(describing: searchBar.text!))", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                
            } ))
            self.present(alert, animated: true, completion: nil)
        }
        
        
        for article in articles {
            if article.urlToImage != nil {
                self.articles.append(article)
            } else {
                print("Not an article: \(article.url)")
            }
        }
        
        searchCollectionView.reloadData()
    }
    
    
    //MARK: CollectionView
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return articles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NewsCell", for: indexPath) as! NewsCell
        
        if let articleImageString = articles[indexPath.row].urlToImage {
            
            var imageURL = URL(string: articleImageString)
            cell.newsImage.kf.indicatorType = .activity
            cell.newsImage.kf.setImage(with: imageURL, options: [.scaleFactor(UIScreen.main.scale),.transition(.fade(1)),.cacheOriginalImage
            ]){
                result in
                switch result {
                case .success( _): break
                case .failure( _): do {
                    imageURL =  URL(string: articleImageString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
                    cell.newsImage.kf.setImage(with: imageURL, options: [.scaleFactor(UIScreen.main.scale),.transition(.fade(1)),
                                                                                                                    .cacheOriginalImage])
                    }
                }
            }
        }
        cell.newsDescription.text = articles[indexPath.row].title
        cell.time.text = "\(calculateNewsDate(publishedAt: articles[indexPath.row].publishedAt))"
        return cell
        
        
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let articleUrl = URL(string: articles[indexPath.row].url)
        
        if let articleUrl = articleUrl {
            if UIApplication.shared.canOpenURL(articleUrl) {
                UIApplication.shared.open(articleUrl, options: [:], completionHandler: nil)
            } else {
                errorAlert(controller: self, title: "Invalid", message: "can't open news article")
            }
        }
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let lastElement = articles.count - 1
        if indexPath.row == lastElement {
            
            if NewsData.searchPage <= NewsData.totalPages {
                isLoading = true
                NewsData.searchPage += 1
                print(NewsData.searchPage)
                NewsAPI.getSearchInEveryThingNews(keyword: search, completionHandler: handleNewsSearchResponse(articles:countryName:error:))
            }
        }
    }
}
