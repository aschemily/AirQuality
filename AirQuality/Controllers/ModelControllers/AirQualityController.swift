//
//  AirQualityController.swift
//  AirQuality
//
//  Created by Emily Asch on 2/24/22.
//

import Foundation

class AirQualityController{
    //MARK: String Constants
    static let baseURL = URL(string: "https://api.airvisual.com")
    static let versionComponent = "v2"
    static let countriesComponent = "countries"
    static let statesComponent = "states"
    static let citiesComponent = "cities"
    static let cityComponent = "city"
    //keys
    static let countryKey = "country"
    static let statesKey = "state"
    static let cityKey = "city"
    //api
    static let apiKeyKey = "key"
    static let apiKeyValue = "13af00b5-02ea-4480-9868-e4943af2e6eb"
    
    //api key- 13af00b5-02ea-4480-9868-e4943af2e6eb
    
    //fetch countries: http://api.airvisual.com/v2/countries?key={{YOUR_API_KEY}}
    static func fetchCountries(completion: @escaping(Result<[String], NetworkError>)-> Void){
        guard let baseURL = baseURL else {return completion(.failure(.invalidURL))}
        let versionURL = baseURL.appendingPathComponent(versionComponent)
        let countriesURL = versionURL.appendingPathComponent(countriesComponent)
        
        var components = URLComponents(url: countriesURL, resolvingAgainstBaseURL: true)
        let apiQuery = URLQueryItem(name: apiKeyKey, value: apiKeyValue)
        components?.queryItems = [apiQuery]
        
        guard let finalURL = components?.url else {return completion(.failure(.invalidURL))}
        
        print("👀final url \(#function) \(finalURL)👀")
        
        //MARK: URL SESSION
        URLSession.shared.dataTask(with: finalURL) { data, _, error in
            if let error = error {
                return completion(.failure(.thrownError(error)))
            }
            
            guard let data = data else {return completion(.failure(.noData))}
            
            do{
                let topLevelObject = try JSONDecoder().decode(Country.self, from: data)
                let countryDicts = topLevelObject.data
                
                var listOfCountryNames: [String] = []
               
                for country in countryDicts{
                    let countryName = country.countryName
                    listOfCountryNames.append(countryName)
                }
                return completion(.success(listOfCountryNames))
            }catch{
                return completion(.failure(.unableToDecode))
            }
        }.resume()
        
    }

    //fetch states: http://api.airvisual.com/v2/states?country={{COUNTRY_NAME}}&key={{YOUR_API_KEY}}
    static func fetchStates(forCountry: String, completion: @escaping(Result<[String], NetworkError>)->Void) {
        //Step 1: set up URL
        guard let baseURL = baseURL else {return completion(.failure(.invalidURL))}
        let versionURL = baseURL.appendingPathComponent(versionComponent)
        let statesURL = versionURL.appendingPathComponent(statesComponent)
        
        var components = URLComponents(url: statesURL, resolvingAgainstBaseURL: true)
        let countryQuery = URLQueryItem(name: countryKey, value: forCountry)
        let apiQuery = URLQueryItem(name: apiKeyKey, value: apiKeyValue)
        
        components?.queryItems = [countryQuery, apiQuery]
        
        guard let finalURL = components?.url else {return completion(.failure(.invalidURL))}
        print("👀states final url \(#function) \(finalURL)👀")
        
        //session
        URLSession.shared.dataTask(with: finalURL) { data, _, error in
            if let error = error {
                return completion(.failure(.thrownError(error)))
            }
            
            //unwrap data
            guard let data = data else {return completion(.failure(.noData))}
            
            do{
                let topLevelObject = try JSONDecoder().decode(State.self, from: data)
                let statesData = topLevelObject.data
                var stateLists: [String] = []
                
                for state in statesData{
                    stateLists.append(state.stateName)
                }
                return completion(.success(stateLists))
            }catch{
                return completion(.failure(.unableToDecode))
            }
        }.resume()
        
    }

    //cities: http://api.airvisual.com/v2/cities?state={{STATE_NAME}}&country={{COUNTRY_NAME}}&key={{YOUR_API_KEY}}
    
    static func fetchCities(forState: String,forCountry: String, completion: @escaping(Result<[String], NetworkError>)-> Void){
        
        guard let baseURL = baseURL else {return completion(.failure(.invalidURL))}
        let versionURL = baseURL.appendingPathComponent(versionComponent)
        let citiesURL = versionURL.appendingPathComponent(citiesComponent)
        
        var components = URLComponents(url: citiesURL, resolvingAgainstBaseURL: true)
        let stateQuery =  URLQueryItem(name: statesKey, value: forState)
        let countryQuery = URLQueryItem(name: countryKey, value: forCountry)
        let apiQuery = URLQueryItem(name: apiKeyKey, value: apiKeyValue)
        
        components?.queryItems = [stateQuery, countryQuery, apiQuery]
        guard let finalURL = components?.url else {return completion(.failure(.invalidURL))}
        print("👀final cities url \(#function) \(finalURL)👀")
        
        URLSession.shared.dataTask(with: finalURL) { data, _, error in
            //first error
          if let error = error {
                return completion(.failure(.thrownError(error)))
            }
            
            guard let data = data else {return completion(.failure(.noData))}
            
            do{
                let topLevelObject = try JSONDecoder().decode(City.self, from: data)
                let cityData = topLevelObject.data
                var cityLists: [String] = []
                
                for city in cityData{
                    cityLists.append(city.cityName)
                }
                return completion(.success(cityLists))
            }catch{
                return completion(.failure(.unableToDecode))
            }
            
        }.resume()
        
    }

    //city data: http://api.airvisual.com/v2/city?city=Los Angeles&state=California&country=USA&key={{YOUR_API_KEY}}
    static func fetchData(forCity: String, inState: String, inCountry: String, completion: @escaping(Result<CityData, NetworkError>)-> Void){
        guard let baseURL = baseURL else {return completion(.failure(.invalidURL))}
        let versionURL = baseURL.appendingPathComponent(versionComponent)
        let cityURL = versionURL.appendingPathComponent(cityComponent)
        
        var components = URLComponents(url: cityURL, resolvingAgainstBaseURL: true)
        let cityQuery = URLQueryItem(name: cityKey, value: forCity)
        let stateQuery = URLQueryItem(name: statesKey, value: inState)
        let countryQuery = URLQueryItem(name: countryKey, value: inCountry)
        let apiQuery = URLQueryItem(name: apiKeyKey, value: apiKeyValue)
        
        components?.queryItems = [cityQuery, stateQuery, countryQuery, apiQuery]
        
        guard let finalURL = components?.url else {return completion(.failure(.invalidURL))}
        print("👀final url in \(#function) \(finalURL)👀")
        
        //data task
        URLSession.shared.dataTask(with: finalURL) { data, _, error in
            if let error = error {
                return completion(.failure(.thrownError(error)))
            }
            
            guard let data = data else {return completion(.failure(.noData))}
            
            do{
                let cityData = try JSONDecoder().decode(CityData.self, from: data)
                return completion(.success(cityData))
            }catch{
                return completion(.failure(.unableToDecode))
            }
        }.resume()
        
    }
 
    
}//end of class
