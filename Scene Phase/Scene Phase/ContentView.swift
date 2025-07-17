//
//  ContentView.swift
//  Scene Phase
//
//  Created by Israel Manzo on 7/16/25.
//

import SwiftUI

struct ContentView: View {
    
    @Environment(\.scenePhase) private var scenePhase
    
    var body: some View {
        VStack {
            Text("Scene Phase App")
                .onChange(of: scenePhase) { oldState, newValue in
                    if newValue == .inactive {
                        print(">>> Scene is inactive <<<")
                    } else if newValue == .active {
                        print(">>> Scene is active <<<")
                    } else if newValue == .background {
                        print(">> Scene is in background")
                    } else {
                        print(">> Unknown scene phase: \(newValue)")
                    }
                }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
