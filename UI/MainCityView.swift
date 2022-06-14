//
//  MainCityView.swift
//  WeatherMonitoring
//
//  Created by n3deep on 25.02.2022.
//

import SwiftUI

struct MainCityView: View {
    
    var name: String
    var celsius: Int
    var fahrenheit: Int
    var backgroundColor: Color
    
    @Binding var isCelsius: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(name)
                .font(.system(size: 36))
            HStack(spacing: 0) {
                Text(isCelsius ? String(celsius) + "°" : String(fahrenheit) + "°")
                        .font(.system(size: 26))

                Spacer()

                HStack(spacing: 8) {
                    Toggle(isOn: $isCelsius) {
                        Text("F")
                          .frame(maxWidth: .infinity, alignment: .trailing)
                          .font(.system(size: 26))
                    }
                    //.toggleStyle(SwitchToggleStyle(tint: Color.green))

                    Text("C")
                        .font(.system(size: 26))
                }

            }
        }
        .padding()
        .background(backgroundColor)
    }
}

struct MainCityView_Previews: PreviewProvider {
    static var previews: some View {
        MainCityView(name: "Test", celsius: 5, fahrenheit: 10, backgroundColor: .blue, isCelsius: .constant(Bool(true)))
    }
}
