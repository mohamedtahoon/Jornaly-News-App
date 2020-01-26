//
//  ViewController.swift
//  Jornaly
//
//  Created by MacBookPro on 1/19/20.
//  Copyright © 2020 MacBookPro. All rights reserved.
//

import UIKit
import Foundation
import CoreData
import FlagKit


class SelectCountriesVC: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var selectCountriesBtn: UIButton!
    @IBOutlet weak var countriesTableView: UITableView!
    
    @IBOutlet weak var welcomeLabel: UILabel!
    
    var isChoosingCountries = false
    var countries = [String]()
    var fetchedCountriesFromDB = [Country]()
    var selectedCountriesFromTable = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        countriesTableView.delegate = self
        countriesTableView.dataSource = self
        countriesTableView.layer.cornerRadius = 10.0
        countriesTableView.isEditing = true
        countriesTableView.allowsMultipleSelectionDuringEditing = true
        fetchCountriesFromDatabaseAndRemoveItFromTable()
        selectCountriesBtn.isEnabled = false
      }

    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        try? context.save()
    }
    
    @IBAction func selectCountriesBtnTapped(_ sender: Any) {
        for selected in selectedCountriesFromTable{
            let country = Country(context: context)
            country.country = selected
            countries.append(country.country!)
        }
        if context.hasChanges{
            try? context.save()
            print("Added\(selectedCountriesFromTable)")
            
        }
        performSegue(withIdentifier: "start", sender: self)
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = countriesTableView.dequeueReusableCell(withIdentifier: "CountryCell", for: indexPath)
        let countryName = countries[indexPath.row]
        cell.textLabel?.text = countryName
        cell.textLabel?.font = .boldSystemFont(ofSize: 16)
        cell.imageView?.image = Flag(countryCode: "\(Countries(rawValue: countryName)!)".uppercased())?.image(style: .none)
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 15
        cell.backgroundColor = UIColor.white
        cell.layer.borderColor = UIColor.lightGray.cgColor
        cell.clipsToBounds = true
        return cell
    }
    

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCountriesFromTable.append(countries[indexPath.row])
        
        if selectedCountriesFromTable.count > 0 || isChoosingCountries {
            selectCountriesBtn.isEnabled = (isChoosingCountries) ? true : true
            selectCountriesBtn.alpha = 1
            selectCountriesBtn.setTitle("Go To Articles", for: .normal)
            
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        selectedCountriesFromTable.remove(at: selectedCountriesFromTable.firstIndex(of: countries[indexPath.row])!)
        if selectedCountriesFromTable.count == 0 && !isChoosingCountries{
            selectCountriesBtn.isEnabled = false
            selectCountriesBtn.alpha = 0.5
            selectCountriesBtn.setTitle("Choose at least one", for: .normal)
        }
    }
    
    
    
    func fetchCountriesFromDatabaseAndRemoveItFromTable(){
        let fetchRequest : NSFetchRequest<Country> = Country.fetchRequest()
        selectCountriesBtn.alpha = (isChoosingCountries) ? 1 : 0.5
        if let fetched = try? context.fetch(fetchRequest){
            fetchedCountriesFromDB = fetched
            countries = Countries.allCases.map{$0.rawValue}
            
            for fetched in fetchedCountriesFromDB{
                selectedCountriesFromTable.append(fetched.country!)
            }
            countries = countries.filter{!selectedCountriesFromTable.contains($0)}
            selectedCountriesFromTable.removeAll()
            countriesTableView.reloadData()
        }
        if isChoosingCountries{
            welcomeLabel.text = "Edit Countries"
            selectCountriesBtn.isEnabled = true
            selectCountriesBtn.setTitle("Done", for: .normal)
        }
        
    }
}

