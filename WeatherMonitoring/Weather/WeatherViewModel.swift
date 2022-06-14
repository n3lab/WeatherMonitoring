//
//  WeatherViewModel.swift
//  WeatherMonitoring
//
//  Created by n3deep on 25.02.2022.
//

import Foundation
import SwiftUI
import Combine

class WeatherViewModel: ObservableObject {
    let apiService: ApiServicing = ApiService()
    
    @ObservedObject var locationService = LocationService()
    @ObservedObject var coredataService = CoreDataService()
    
    /*
    @Published var cities = [City(id: 1, name: "Moscow", celsius: 10, fahrenheit: 100, date: Date(), minCelsius: -30, maxCelsius: 30, minFahrenheit: -40, maxFahrenheit: 40),
                  City(id: 2, name: "London", celsius: 25, fahrenheit: 250, date: Date(), minCelsius: -30, maxCelsius: 30, minFahrenheit: -40, maxFahrenheit: 40),
                  City(id: 3, name: "Ontario", celsius: 35, fahrenheit: 350, date: Date(), minCelsius: -30, maxCelsius: 30, minFahrenheit: -40, maxFahrenheit: 40)]
    */
    
    @Published var cities: [City] = []
    var allCities: [City] = []
    
    @Published var currentCity: City?
    var currentCityViewColor: Color?
    
    @Published var isCelsius = true
    
    private var subscriptions = Set<AnyCancellable>()
    
    init() {
        locationService.$location.sink { location in

            print("changed location")
            
            let latitude = location?.latitude ?? 0
            let longitude = location?.longitude ?? 0
            
            self.apiService.fetchWeather(byLatitude: latitude, andLongitude: longitude, onSuccess: { city in
                self.updateCurrentCityView(withCity: city)
            }, onFailure: { error in
                print(error)
            })
            
        }.store(in: &subscriptions)
        
        coredataService.$savedEntities.sink { savedCities in
            let allCities: [City] = self.coredataService.convertToCities(savedCities)
            
            let sortedCities = allCities.sorted(by: { $0.date > $1.date })
            self.allCities = sortedCities
            
            var lastCities: [City] = []
            for city in sortedCities {
                if lastCities.filter({ $0.id == city.id }).count < 1 {
                    var mutatingCity = city
                    if sortedCities.filter({ $0.id == city.id }).count > 1 {
                        mutatingCity.hasGraph()
                    }
                    lastCities.append(mutatingCity)
                }
            }
            
            DispatchQueue.main.async {
                self.cities = lastCities
            }
        }.store(in: &subscriptions)
    }
        
    func fetchWeather(byCityName cityName: String) {
        apiService.fetchWeather(byCityName: cityName, onSuccess: { city in
            self.updateCurrentCityView(withCity: city)
            self.coredataService.addCity(city: city)
        }, onFailure: { error in
            print(error)
        })
    }
    
    func deleteCity(indexSet: IndexSet) {
        guard let index = indexSet.first else { return }
        let city = cities[index]
        coredataService.deleteCity(withId: city.id)
    }
    
    func fetchWeatherFromCurrentLocation() {
        locationService.requestLocation()
    }
    
    private func updateCurrentCityView(withCity city: City) {
        DispatchQueue.main.async {
            print(city)
            self.currentCity = city
            
            switch city.celsius {
            case ..<10:
                self.currentCityViewColor = .cyan
            case 10...25:
                self.currentCityViewColor = .orange
            case 25...:
                self.currentCityViewColor = .red
            default:
                self.currentCityViewColor = .clear
            }
        }
    }
}
