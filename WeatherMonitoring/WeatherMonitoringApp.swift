//
//  WeatherMonitoringApp.swift
//  WeatherMonitoring
//
//  Created by n3deep on 25.02.2022.
//

import SwiftUI

@main
struct WeatherMonitoringApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
