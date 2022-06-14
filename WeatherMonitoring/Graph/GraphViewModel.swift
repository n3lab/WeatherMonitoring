//
//  GraphViewModel.swift
//  WeatherMonitoring
//
//  Created by n3deep on 28.02.2022.
//

import Foundation

class GraphViewModel: ObservableObject {
    
    private let cityId: Int
    private var allCities: [City] = []
    
    var cityName: String
    
    var temperatureArray: [Double]
    var temperatureMax: Int?
    var temperatureMin: Int?
    
    init(cityId: Int, allCities: [City]) {
        self.cityId = cityId
        self.cityName = allCities.filter { $0.id == cityId }.first?.name ?? "unknown"
        self.allCities = allCities
        
        let sortedCities = allCities.sorted(by: { $0.date < $1.date })
        self.allCities = sortedCities
        self.temperatureArray = allCities.filter { $0.id == cityId }.map { $0.temperature }
        self.temperatureMin = allCities.filter { $0.id == cityId }.first?.minCelsius
        self.temperatureMax = allCities.filter { $0.id == cityId }.first?.maxCelsius
        print("city name: \(cityName)")
        print("city temp array: \(temperatureArray)")
        print("city min temp: \(String(describing: temperatureMin))")
        print("city max temp: \(String(describing: temperatureMax))")
    }
}
