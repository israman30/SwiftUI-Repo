//
//  CountryViewDetail.swift
//  NavigationStack
//
//  Created by Israel Manzo on 5/6/24.
//

import SwiftUI

struct CountryViewDetail: View {
    var country: Country
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(country.flag)
                Text(country.name)
            }
            .font(.largeTitle)
            List(country.cities) { city in
                NavigationLink(value: city) {
                    Text(city.name)
                }
            }
        }
        .padding()
        .navigationTitle("Country")
        .navigationDestination(for: City.self) { city in
            CityView(city: city)
        }
    }
}

#Preview {
    CountryViewDetail(country: Country.countries[2])
        .environmentObject(Router())
}

struct CityView: View {
    @EnvironmentObject var router: Router
    var city: City
    var body: some View {
        VStack {
            Text(city.name)
                .font(.largeTitle)
            Button {
                self.router.reset()
            } label: {
                Text("Back to Main")
            }
            .buttonStyle(.borderedProminent)
        }
    }
}
