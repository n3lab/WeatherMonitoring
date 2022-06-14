//
//  Date+Extension.swift
//  WeatherMonitoring
//
//  Created by n3deep on 27.02.2022.
//

import Foundation

extension Date {
    private func getFormattedDate(format: String) -> String {
        let dateformat = DateFormatter()
        dateformat.dateFormat = format
        return dateformat.string(from: self)
    }
    
    func formatDate() -> String {
        let formattedDate = self.getFormattedDate(format: "dd.MM.yyyy HH:mm:ss")
        return formattedDate
    }
}
