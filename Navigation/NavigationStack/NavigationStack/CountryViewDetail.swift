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
    }
}

#Preview {
    CountryViewDetail(country: Country.countries[2])
}
