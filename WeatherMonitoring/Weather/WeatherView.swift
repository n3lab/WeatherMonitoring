//
//  WeatherView.swift
//  WeatherMonitoring
//
//  Created by n3deep on 25.02.2022.
//

import SwiftUI

struct WeatherView: View {
    @ObservedObject var viewModel: WeatherViewModel
    @State private var searchText = ""
    
    @State private var graph: (show: Bool, id: Int) = (false, 0)
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                
                NavigationLink(destination: GraphView(viewModel: GraphViewModel(cityId: graph.id, allCities: viewModel.allCities)), isActive: $graph.show, label: { EmptyView() })
                    .disabled(true)
                    .hidden()
                
                Spacer()

                MainCityView(name: viewModel.currentCity?.name ?? "Test town", celsius: viewModel.currentCity?.celsius ?? 5, fahrenheit: viewModel.currentCity?.fahrenheit ?? 10, backgroundColor: viewModel.currentCityViewColor ?? .clear, isCelsius: $viewModel.isCelsius )
                 
                List() {
                    ForEach(viewModel.cities) { city in
                            CityCell(id: city.id, name: city.name, celsius: city.celsius, fahrenheit: city.fahrenheit, date: city.date.formatDate(), isCelsius: $viewModel.isCelsius, graph: $graph, hasGraph: city.graph)
                    }
                    .onDelete(perform: removeRows)
                }
                .listStyle(PlainListStyle())
                //.colorMultiply(.white)
            }
            
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        print("Location button was tapped")
                        viewModel.fetchWeatherFromCurrentLocation()
                    } label: {
                        Image(systemName: "location.north.circle")
                            .foregroundColor(.blue)
                    }
                }
            }
            .navigationBarTitle("Weather", displayMode: .inline)
        }
        .searchable(text: $searchText, prompt: "City name")
        .onChange(of: searchText) { value in
            if !value.isEmpty &&  value.count > 2 {
                viewModel.fetchWeather(byCityName: value)
            }
        }
    }
    
    func removeRows(at offsets: IndexSet) {
        //viewModel.cities.remove(atOffsets: offsets)
        viewModel.deleteCity(indexSet: offsets)
    }
}

struct WeatherView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherView(viewModel: WeatherViewModel())
    }
}

