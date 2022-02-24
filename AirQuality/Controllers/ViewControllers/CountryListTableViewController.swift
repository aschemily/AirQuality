//
//  CountryListTableViewController.swift
//  AirQuality
//
//  Created by Emily Asch on 2/24/22.
//

import UIKit

class CountryListTableViewController: UITableViewController {
    
    //MARK: Properties
    var countries: [String] = []
    //MARK: Lifecyles

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchCountries()
    }
    
    //MARK: Helper
    
    func fetchCountries(){
        AirQualityController.fetchCountries { result in
            DispatchQueue.main.async {
                switch result{
                case .success(let countries):
                    self.countries = countries
                    self.tableView.reloadData()
                case .failure(let error):
                    print("🔴error in \(#function), \(error.localizedDescription)🔴")
                }
            }
        }
    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return countries.count
    }

 
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "countryCell", for: indexPath)
        let country = countries[indexPath.row]
        
        cell.textLabel?.text = country

        return cell
    }
  
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       //IIDOO
        if segue.identifier == "toStatesVC"{
            guard let indexPath = tableView.indexPathForSelectedRow,
                  let destination = segue.destination as? StateListTableViewController else {return}
            let country = countries[indexPath.row]
            destination.country = country
        }
    }


}//end of class
