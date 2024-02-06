//
//  ViewModel.swift
//  MapKit Autocomplete
//
//  Created by Israel Manzo on 2/5/24.
//

import SwiftUI
import  MapKit

class ViewModel: NSObject, ObservableObject, MKLocalSearchCompleterDelegate {
    @Published private(set) var results: [AddressResult] = []
    @Published var searchText = ""
    
    private var localSearchCompleter: MKLocalSearchCompleter {
        let completer = MKLocalSearchCompleter()
        completer.delegate = self
        return completer
    }
    
    func searhAddress(searchText: String) {
        guard searchText.isEmpty == false else { return }
        localSearchCompleter.queryFragment = searchText
    }
    
    @MainActor
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        Task {
            results = completer.results
                .map {
                    AddressResult(title: $0.title, subtitle: $0.subtitle)
                }
        }
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        // ---
    }
}
