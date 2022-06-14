//
//  GraphView.swift
//  WeatherMonitoring
//
//  Created by n3deep on 28.02.2022.
//

import SwiftUI
import LightChart

struct GraphView: View {

    @ObservedObject var viewModel: GraphViewModel
    
    var body: some View {
            VStack(alignment: .leading, spacing: 20) {
                LightChartView(data: viewModel.temperatureArray,
                               type: .curved,
                               visualType: .outline(color: .green, lineWidth: 5),
                               offset: 0.3)
                    .frame(height: 300, alignment: .center)
                    .padding()
                    .border(.gray, width: 2)
                Text("Min temperature: \(String(viewModel.temperatureMin ?? 0)) °C")
                    .font(.system(size: 26))
                Text("Max temperature: \(String(viewModel.temperatureMax ?? 0)) °C")
                    .font(.system(size: 26))
                Spacer()
            }
            .padding()
            .navigationTitle("Graph for \(viewModel.cityName)")
    }
}

struct GraphView_Previews: PreviewProvider {
    static var previews: some View {
        GraphView(viewModel: GraphViewModel(cityId: 123, allCities: []))
    }
}
