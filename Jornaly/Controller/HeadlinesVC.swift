//
//  HeadlinesVC.swift
//  Jornaly
//
//  Created by MacBookPro on 1/19/20.
//  Copyright © 2020 MacBookPro. All rights reserved.
//

import UIKit
import CoreData
import Kingfisher
import BTNavigationDropdownMenu



class HeadlinesVC: UIViewController ,UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    @IBOutlet weak var selectedCellLabel: UINavigationItem!
    var menuView: BTNavigationDropdownMenu!
    
    var category = ""
        
    var refresh = UIRefreshControl()
    
    var articles = [Article]()
    var countries = [String]()
    var loadedCountries = [Country]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        setupNewsHeadlines()
        prepareDropDownMenu()
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getDataFromCoreData()
    }
    override func viewDidAppear(_ animated: Bool) {
        refreshView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        category = ""
    }
    
    @objc func refreshView(){
        navigationItem.rightBarButtonItem!.isEnabled = false
        articles.removeAll()
        countries.removeAll()
        collectionView.reloadData()
        
        getHeadlinesForChoosedCountries(countries: loadedCountries)
    }
    
    
    func handleHeadlineNewsResponse(articles: [Article] ,countryName: String, error: Error?) {
        if error != nil  {
            navigationItem.rightBarButtonItem!.isEnabled = true
            return
        }
        navigationItem.rightBarButtonItem!.isEnabled = true
        
        for article in articles {
            if article.urlToImage != nil{
                self.articles.append(article)
                self.countries.append(countryName)
            }
        }
        if refresh.isRefreshing {
            refresh.endRefreshing()
        }
        collectionView.reloadData()
    }
    
    func getHeadlinesForChoosedCountries(countries: [Country]){
        for country in countries {
            NewsAPI.getHeadlineNews(countryName: ["\(Countries(rawValue: country.country!)!)", country.country!], categoryName: category, completion: handleHeadlineNewsResponse(articles:countryName:error:))
        }
    }
    
    func setupNewsHeadlines(){
        self.refresh.addTarget(self, action: #selector(refreshView), for: .valueChanged)
        collectionView.addSubview(refresh)
        
        getDataFromCoreData()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "refresh"), style: .plain, target: self, action: #selector(refreshView))
        navigationItem.rightBarButtonItem!.isEnabled = false
        
        getHeadlinesForChoosedCountries(countries: loadedCountries)
    }
    
    
    func getDataFromCoreData(){
        
        let fetchRequest: NSFetchRequest<Country> = Country.fetchRequest()
        fetchRequest.sortDescriptors = []
        if let result = try? context.fetch(fetchRequest){
            loadedCountries = result
        }
    }
    
    
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
                    cell.newsImage.kf.setImage(with: imageURL, options: [.scaleFactor(UIScreen.main.scale),.transition(.fade(1)), .cacheOriginalImage])
                    }
                }
            }
        }
        
        cell.newsDescription.text = articles[indexPath.row].title
        cell.time.text = "\(calculateNewsDate(publishedAt: articles[indexPath.row].publishedAt))"
        cell.country.text = "\(countries[indexPath.row])"
        
        return cell
    }
    
    
    // open news article url
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        var articleUrl = URL(string: articles[indexPath.row].url)
        if let articleUrl = articleUrl {
            openUrl(articleUrl)
        } else {
            articleUrl = URL(string: articles[indexPath.row].url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
            guard let articleUrl = articleUrl else { return }
            openUrl(articleUrl)
        }
    }
    
    
    
    
    // Prepare Category DropDown Menu
    let categories = ["HeadLines", "Business", "Entertainment", "Health", "Science", "Sports", "Technology"]

        func prepareDropDownMenu() {
            self.selectedCellLabel.title = categories[0]
                self.navigationController?.navigationBar.isTranslucent = false
                self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    
                menuView = BTNavigationDropdownMenu(navigationController: self.navigationController, containerView: self.navigationController!.view, title: BTTitle.index(0), items: categories)
    
    
                menuView.cellHeight = 50
                menuView.cellBackgroundColor = self.navigationController?.navigationBar.barTintColor
                menuView.cellSelectionColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
                menuView.shouldKeepSelectedCellColor = true
                menuView.cellTextLabelColor = UIColor.white
                menuView.cellTextLabelFont = UIFont(name: "Avenir-Heavy", size: 19)
                menuView.cellTextLabelAlignment = .center // .Right // .Left
                menuView.arrowPadding = 15
                menuView.cellSeparatorColor = .gray
                menuView.animationDuration = 0.5
                menuView.maskBackgroundColor = UIColor.gray
                menuView.maskBackgroundOpacity = 0.3
                menuView.didSelectItemAtIndexHandler = {(indexPath: Int) -> Void in
                    print("Did select item at index: \(indexPath)")
                    self.selectedCellLabel.title = self.categories[indexPath]
                    self.category = self.categories[indexPath]
                    self.refreshView()
                    self.collectionView.reloadData()
                }
    
                self.navigationItem.titleView = menuView
        }
}

