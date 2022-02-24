//
//  StateListTableViewController.swift
//  AirQuality
//
//  Created by Emily Asch on 2/24/22.
//

import UIKit

class StateListTableViewController: UITableViewController {
    
    //MARK: Properties
    var country: String?
    var states: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchStates()

    }
    
    //MARK: Helper methods
    
    func fetchStates(){
        guard let country = country else {return}
        AirQualityController.fetchStates(forCountry: country) { result in
            DispatchQueue.main.async {
                switch result{
                case .success(let states):
                    self.states = states
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
        return states.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "stateCell", for: indexPath)
        let state = states[indexPath.row]
        
        cell.textLabel?.text = state
        return cell
    }
 

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //IIDOO
        //identifier
        if segue.identifier == "toCityVC"{
            //index path
            guard let indexPath = tableView.indexPathForSelectedRow,
                  let destination = segue.destination as? CityListTableViewController else {return}
            //object to send
            let state = states[indexPath.row]
            destination.country = country
            destination.state = state
        }
    }


}//end of class
