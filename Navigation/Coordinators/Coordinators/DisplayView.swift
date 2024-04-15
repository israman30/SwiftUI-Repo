//
//  DisplayView.swift
//  Coordinators
//
//  Created by Israel Manzo on 4/14/24.
//

import SwiftUI

struct DisplayView: View {
    @EnvironmentObject private var coordinator: Coordinator
    
    var body: some View {
        ZStack {
            Color.yellow
            Text("Display View")
                .font(.largeTitle)
                .onTapGesture {
                    coordinator.dismissFullScreenSheet()
                }
        }
    }
}

#Preview {
    DisplayView()
}
