//
//  HomeView.swift
//  MapKit Autocomplete
//
//  Created by Israel Manzo on 2/5/24.
//

import SwiftUI

struct HomeView: View {
    
    @StateObject var vm: ViewModel
    @FocusState private var isFocusedText: Bool
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 0) {
                TextField("Address...", text: $vm.searchText)
                    .padding()
                    .autocorrectionDisabled()
                    .focused($isFocusedText)
                    .font(.title)
                    .onReceive(vm.$searchText.debounce(for: .seconds(1), scheduler: DispatchQueue.main), perform: { address in
                        vm.searhAddress(searchText: address)
                    })
                    .background(Color(.systemBackground))
                    .overlay {
                        HStack {
                            Spacer()
                            Button {
                                
                            } label: {
                                Image(systemName: "xmark.circle.fill")
                            }
                        }
                        
                    }
                    .onAppear {
                        isFocusedText = true
                    }
                List(vm.results) { address in
                    VStack {
                        Text(address.title)
                        Text(address.subtitle)
                    }
                    
                }
            }
        }
    }
}

#Preview {
    HomeView(vm: ViewModel())
}
