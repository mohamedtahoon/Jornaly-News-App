//
//  EditCountriesVC.swift
//  Jornaly
//
//  Created by MacBookPro on 1/21/20.
//  Copyright © 2020 MacBookPro. All rights reserved.
//

import UIKit
import CoreData
import FlagKit

class EditCountriesVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var height: NSLayoutConstraint!
    @IBOutlet weak var editCoutriesTableView: UITableView!
    
    
    var countries = [Country]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        editCoutriesTableView.delegate = self
        editCoutriesTableView.dataSource = self
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain , target: self , action: #selector(addNewCountry))
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain , target: self , action: #selector(editCountries))
        
        editCoutriesTableView.layer.cornerRadius = 10.0
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadCountries()
    }
    
    
    
    @objc func addNewCountry() {
        var selectCountriesVC = SelectCountriesVC()
        selectCountriesVC = storyboard?.instantiateViewController(withIdentifier: "SelectCountriesVC") as! SelectCountriesVC
        selectCountriesVC.isChoosingCountries = true
        present(selectCountriesVC, animated: true, completion: nil)
        selectCountriesVC.selectCountriesBtn.isEnabled = true

    }
    
    @objc func editCountries(){
        if editCoutriesTableView.isEditing != true{
            editCoutriesTableView.isEditing = true
            navigationItem.leftBarButtonItem?.title = "Done"
        }else{
            editCoutriesTableView.isEditing = false
            navigationItem.leftBarButtonItem?.title = "Edit"
        }
    }
    
    
    
    func reloadCountries(){
        let fetchRequest: NSFetchRequest<Country> = Country.fetchRequest()
        if let fetched = try? context.fetch(fetchRequest){
            countries = fetched
        }
        editCoutriesTableView.reloadData()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = editCoutriesTableView.dequeueReusableCell(withIdentifier: "CountryCell", for: indexPath)
        let countryName = countries[indexPath.row]
        cell.textLabel?.text = countryName.country
        cell.selectionStyle = .none
        cell.imageView?.image = Flag(countryCode: "\(Countries(rawValue: countryName.country!)!)".uppercased())?.image(style: .none)
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 15
        cell.backgroundColor = UIColor.white
        cell.layer.borderColor = UIColor.lightGray.cgColor
        cell.clipsToBounds = true

        return cell
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        if editCoutriesTableView.isEditing {
            return .delete
        }
        return .none
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            if countries.count > 1 {
                let countryToDelete = countries[indexPath.row]
                context.delete(countryToDelete)
                if context.hasChanges {
                    try? context.save()
                }
                countries.remove(at: indexPath.row)
                tableView.reloadData()
            } else {
                errorAlert(controller: self, title: "Sorry", message: "Must have at least one Country")
                editCoutriesTableView.isEditing = true
                navigationItem.leftBarButtonItem?.title = "OK"
            }
        }
    }
}
