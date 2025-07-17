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
                    printScenePhase(newValue)
                }
        }
        .padding()
    }
    
    private func printScenePhase(_ scenePhase: ScenePhase?) {
        if scenePhase == .inactive {
            print(">>> Scene is inactive <<<")
        } else if scenePhase == .active {
            print(">>> Scene is active <<<")
        } else if scenePhase == .background {
            print(">> Scene is in background")
        } else {
            print(">> Unknown scene phase: \(String(describing: scenePhase))")
        }
    }
}

#Preview {
    ContentView()
}
