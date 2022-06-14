//
//  WeatherMonitoringApp.swift
//  WeatherMonitoring
//
//  Created by n3deep on 25.02.2022.
//

import SwiftUI

@main
struct WeatherMonitoringApp: App {
    var body: some Scene {
        WindowGroup {
            WeatherView(viewModel: WeatherViewModel())
        }
    }
}
