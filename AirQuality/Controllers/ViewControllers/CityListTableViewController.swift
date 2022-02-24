//
//  CityListTableViewController.swift
//  AirQuality
//
//  Created by Emily Asch on 2/24/22.
//

import UIKit

class CityListTableViewController: UITableViewController {
    
    //MARK: Properties
    var country: String?
    var state: String?
    var cities: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchCities()
    }
    
    //MARK: Helper methods
    func fetchCities(){
        guard let state = state,
              let country = country else {return}
        AirQualityController.fetchCities(forState: state, forCountry: country) { result in
            DispatchQueue.main.async {
                switch result{
                case .success(let cities):
                    self.cities = cities
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
        return cities.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cityCell", for: indexPath)
        let city = cities[indexPath.row]
        
        cell.textLabel?.text = city
        return cell
    }
 
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toCityDataVC"{
            guard let indexPath = tableView.indexPathForSelectedRow,
                  let destination = segue.destination as? CityDataViewController else {return}
            let city = cities[indexPath.row]
            
            destination.country = country
            destination.state = state
            destination.city = city 
        
        }
    }
    

}
