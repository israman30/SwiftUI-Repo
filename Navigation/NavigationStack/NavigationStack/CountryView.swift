//
//  CountryView.swift
//  NavigationStack
//
//  Created by Israel Manzo on 5/6/24.
//

import SwiftUI

// MARK: - MODEL -
struct Country: Identifiable, Hashable {
    let name: String
    let flag: String
    let cities: [City]
    
    var id: String {
        name
    }
    
    static var countries: [Country] {[
        .init(name: "USA", flag: "🇺🇸", cities: City.cities.filter { $0.name == "Washington DC" }),
        .init(name: "Ecuador", flag: "🇪🇨", cities: City.cities.filter { $0.name == "Quito" }),
        .init(name: "Italy", flag: "🇮🇹", cities: City.cities.filter { $0.name == "Rome" }),
        .init(name: "Spain", flag: "🇪🇸", cities: City.cities.filter { $0.name == "Madrid" }),
        .init(name: "Croatia", flag: "🇭🇷", cities: City.cities.filter { $0.name == "Bool" })
    ]}
}

struct City: Identifiable, Hashable {
    let name: String
    var id: String {
        name
    }
    
    static var cities: [City] {[
        .init(name: "Washington DC"),
        .init(name: "Quito"),
        .init(name: "Rome"),
        .init(name: "Madrid"),
        .init(name: "Bool")
    ]}
}

// MARK: - VIEW - 
struct CountryView: View {
    
    @EnvironmentObject var router: Router
    
    var body: some View {
        NavigationStack(path: $router.path) {
            List(Country.countries) { country in
                NavigationLink(value: country) {
                    Text(country.name)
                }
            }
            .navigationDestination(for: Country.self) { country in
                CountryViewDetail(country: country)
            }
            .navigationTitle("Countries")
        }
    }
}

#Preview {
    CountryView()
        .environmentObject(Router())
}
