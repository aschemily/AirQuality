//
//  CityDataViewController.swift
//  AirQuality
//
//  Created by Emily Asch on 2/24/22.
//

import UIKit

class CityDataViewController: UIViewController {
    
    //MARK: outlets
    @IBOutlet weak var cityStateCountryLabel: UILabel!
    @IBOutlet weak var aqiLabel: UILabel!
    @IBOutlet weak var wsLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var latLongLabel: UILabel!
    
    //MARK: properties
    var country: String?
    var state: String?
    var city: String?

    //MARK: Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
    }
    
    func fetchData(){
        guard let city = city,
                let state = state,
              let country = country else {return}
        AirQualityController.fetchData(forCity: city, inState: state, inCountry: country) { result in
            DispatchQueue.main.async {
                switch result{
                case .success(let cityData):
                    self.updateView(with: cityData)
                case .failure(let error):
                    print("🔴error in \(#function), \(error.localizedDescription)🔴")
                }
            }
        }
    }
    
    func updateView(with cityData: CityData){
        let data = cityData.data
        
        cityStateCountryLabel.text = "\(data.city), \(data.state), \(data.country)"
        aqiLabel.text = "Air Quality Index: \(data.current.pollution.aqius)"
        wsLabel.text = "Windspeed: \(data.current.weather.ws)"
        tempLabel.text = "Temperature: \(data.current.weather.tp)"
        humidityLabel.text = "Humidity: \(data.current.weather.hu)"
        
        
        let coordinates = data.location.coordinates
        if coordinates.count == 2{
            latLongLabel.text = "latitude:\(coordinates[1]) longitude: \(coordinates[0])"
        }else {
            latLongLabel.text = "coordinates unknown"
        }
    }
    


}//end of class
