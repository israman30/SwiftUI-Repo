//
//  MapView.swift
//  MapKit Autocomplete
//
//  Created by Israel Manzo on 2/5/24.
//

import SwiftUI
import MapKit

struct MapView: View {
    
    @StateObject private var vm = MapViewModel()
    private let address: AddressResult
    
    init(_ address: AddressResult) {
        self.address = address
    }
    
    var body: some View {
        Map(coordinateRegion: $vm.region, annotationItems: vm.annotaion) { item in
            MapMarker(coordinate: item.coordinate)
        }
        .onAppear {
            self.vm.getPlaces(from: address)
        }
        .ignoresSafeArea()
    }
}

#Preview {
    MapView(AddressResult(title: "110 cormit street", subtitle: ""))
}
