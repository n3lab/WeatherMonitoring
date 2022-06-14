//
//  ApiService.swift
//  WeatherMonitoring
//
//  Created by n3deep on 25.02.2022.
//

import Foundation

protocol ApiServicing {
    func fetchWeather(byCityName cityName: String, onSuccess: @escaping (City) -> Void, onFailure: @escaping (String) -> Void)
    func fetchWeather(byLatitude latitude: Double, andLongitude longitude: Double, onSuccess: @escaping (City) -> Void, onFailure: @escaping (String) -> Void)
}

private struct CityApiResponse: Codable {
    let id: Int
    let name: String
    let main: MainApiResponse
    
    func convertToCity() -> City {
        let temperature = Double(main.temp)
        
        let celsius = convertToCelsius(main.temp)
        let fahrenheit = convertToFahrenheit(main.temp)
        
        let minCelsius = convertToCelsius(main.minTemp)
        let maxCelsius = convertToCelsius(main.maxTemp)
        
        let minFahrenheit = convertToFahrenheit(main.minTemp)
        let maxFahrenheit = convertToFahrenheit(main.maxTemp)
        
        let date = Date()
        
        return City(id: id, name: name, temperature: temperature, celsius: celsius, fahrenheit: fahrenheit, date: date, minCelsius: minCelsius, maxCelsius: maxCelsius, minFahrenheit: minFahrenheit, maxFahrenheit: maxFahrenheit, graph: false)
    }
    
    private func convertToCelsius(_ temp: Float) -> Int {
        return Int(temp - 273.15)
    }
    
    private func convertToFahrenheit(_ temp: Float) -> Int {
        return Int(temp * 9/5 - 459.67)
    }
}

private struct MainApiResponse: Codable {
    let temp: Float
    let minTemp: Float
    let maxTemp: Float
    
    enum CodingKeys: String, CodingKey {
        case temp
        case minTemp = "temp_min"
        case maxTemp = "temp_max"
    }
}

class ApiService: ApiServicing {
    let apiURL: String = "https://api.openweathermap.org/data/2.5"
    let apiKey: String = "1cc824b727f4cd17cd874e202bc012d2"
    
    func fetchWeather(byCityName cityName: String, onSuccess: @escaping (City) -> Void, onFailure: @escaping (String) -> Void) {
        let replacedCityName = cityName.replacingOccurrences(of: " ", with: "+")
        if let url = URL(string: apiURL + "/weather?q=" + replacedCityName + "&appid=" + apiKey) {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data {
                    //print("data: \(String(describing: String(bytes: data, encoding: String.Encoding.utf8)))")
                    let jsonDecoder = JSONDecoder()
                    do {
                        let parsedJSON = try jsonDecoder.decode(CityApiResponse.self, from: data)
                        onSuccess(parsedJSON.convertToCity())
                    } catch {
                        onFailure("error parsing json: \(error)")
                    }
                }
           }.resume()
        }
    }
    
    func fetchWeather(byLatitude latitude: Double, andLongitude longitude: Double, onSuccess: @escaping (City) -> Void, onFailure: @escaping (String) -> Void) {
        let urlString = apiURL + "/weather?lat=" + String(latitude) + "&lon=" + String(longitude) + "&appid=" + apiKey
        if let url = URL(string: urlString) {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data {
                    //print("data: \(String(describing: String(bytes: data, encoding: String.Encoding.utf8)))")
                    let jsonDecoder = JSONDecoder()
                    do {
                        let parsedJSON = try jsonDecoder.decode(CityApiResponse.self, from: data)
                        onSuccess(parsedJSON.convertToCity())
                    } catch {
                        onFailure("error parsing json: \(error)")
                    }
                }
           }.resume()
        }
    }
}
