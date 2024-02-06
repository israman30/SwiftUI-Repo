//
//  AddressResult.swift
//  MapKit Autocomplete
//
//  Created by Israel Manzo on 2/5/24.
//

import Foundation
import MapKit

struct AddressResult: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
}

struct AnnotationItem: Identifiable {
    let id = UUID()
    let latitude: Double
    let longitude: Double
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
