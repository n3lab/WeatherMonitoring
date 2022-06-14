//
//  CityCell.swift
//  WeatherMonitoring
//
//  Created by n3deep on 25.02.2022.
//

import SwiftUI

struct CityCell: View {
    
    var id: Int
    var name: String
    var celsius: Int
    var fahrenheit: Int
    var date: String
    
    @Binding var isCelsius: Bool
    @Binding var graph: (show: Bool, id: Int)
    
    var hasGraph: Bool
    
    var body: some View {
        HStack() {
            VStack(alignment: .leading, spacing: 10) {
                HStack(spacing: 0) {
                    Text(name)
                    Text(", ")
                    Text(isCelsius ? String(celsius) + "°C" : String(fahrenheit) + "°F")
                }
                Text(date)
            }
            Spacer()
            Button {
                graph = (show: true, id: id)
            } label: {
                Image(systemName: "doc.text.magnifyingglass")
                    .foregroundColor(.blue)
            }
            .buttonStyle(BorderlessButtonStyle())
            .opacity(hasGraph ? 1 : 0)
        }
        .padding(.vertical, 10)
    }
}

struct CityCell_Previews: PreviewProvider {
    static var previews: some View {
        CityCell(id: 12345, name: "test", celsius: 0, fahrenheit: 10, date: "test", isCelsius: .constant(Bool(true)), graph: .constant((show: false, id: 123)), hasGraph: true)
    }
}
