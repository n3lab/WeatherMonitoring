//
//  CoredataService.swift
//  WeatherMonitoring
//
//  Created by n3deep on 25.02.2022.
//

import Foundation
import CoreData

class CoreDataService: ObservableObject {
    
    let container: NSPersistentContainer
    
    @Published var savedEntities: [CityEntity] = []

    init() {
        container = NSPersistentContainer(name: "WeatherMonitoring")
        container.loadPersistentStores { (description, error) in
            if let error = error {
                print("ERROR LOADING CORE DATA. \(error)")
            }
        }
        fetchCities()
    }

    func convertToCities(_ entities: [CityEntity]) -> [City] {
        var cities: [City] = []
        for cityEntity in entities {
            if let name = cityEntity.name, let date = cityEntity.date {
                let city = City(id: Int(cityEntity.id), name: name, temperature: cityEntity.temperature, celsius: Int(cityEntity.celsius), fahrenheit: Int(cityEntity.fahrenheit), date: date, minCelsius: Int(cityEntity.mincelsius), maxCelsius: Int(cityEntity.maxcelsius), minFahrenheit: Int(cityEntity.minfahrenheit), maxFahrenheit: Int(cityEntity.maxfahrenheit), graph: false)
                cities.append(city)
            }
        }
        return cities
    }
    
    func fetchCities() {
        let request = NSFetchRequest<CityEntity>(entityName: "CityEntity")
        do {
            savedEntities = try container.viewContext.fetch(request)
        } catch let error {
            print("Error fetching. \(error)")
        }
    }

    func addCity(city: City) {
        let newCity = CityEntity(context: container.viewContext)
        newCity.id = Int32(city.id)
        newCity.name = city.name
        newCity.date = city.date
        newCity.temperature = city.temperature
        newCity.celsius = Int32(city.celsius)
        newCity.fahrenheit = Int32(city.fahrenheit)
        
        newCity.mincelsius = Int32(city.minCelsius)
        newCity.minfahrenheit = Int32(city.minFahrenheit)
        newCity.maxcelsius = Int32(city.maxCelsius)
        newCity.maxfahrenheit = Int32(city.maxFahrenheit)
        
        saveData()
    }
    
    func deleteCity(withId id: Int) {
        for entity in savedEntities {
            if entity.id == id {
                container.viewContext.delete(entity)
            }
        }
        saveData()
    }
    
    func saveData() {
        do {
            try container.viewContext.save()
            fetchCities()
        } catch let error {
            print("Error saving. \(error)")
        }
    }
     
 }
