//
//  City.swift
//  WeatherMonitoring
//
//  Created by n3deep on 06.03.2022.
//

import Foundation

struct City: Identifiable {
    let id: Int
    let name: String
    let temperature: Double
    let celsius: Int
    let fahrenheit: Int
    let date: Date

    let minCelsius: Int
    let maxCelsius: Int
    
    let minFahrenheit: Int
    let maxFahrenheit: Int
    
    var graph: Bool
    
    mutating func hasGraph() {
        graph = true
    }
}

