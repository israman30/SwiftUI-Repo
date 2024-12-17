//
//  ContentView.swift
//  Alert Component
//
//  Created by Israel Manzo on 12/16/24.
//

import SwiftUI

struct AlertObject {
    let title: String
    let message: String
}

struct ContentView: View {
    @State var isPresented: Bool = false
    @State var alertObject = AlertObject(title: "Alert title", message: "This is a message.!")
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
            Button("Show Alert") {
                self.isPresented.toggle()
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .alert(isPresented: $isPresented) {
            Alert(title: Text(alertObject.title), message: Text(alertObject.message), dismissButton: .default(Text("Ok")))
        }
    }
}

#Preview {
    ContentView()
}
