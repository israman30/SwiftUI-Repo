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

enum AlertComponent {
    case success
    case failure
    
    var title: String {
        switch self {
        case .success:
            return "Success!"
        case .failure:
            return "Failure!"
        }
    }
    
     var message: String {
        switch self {
        case .success:
            return "Your request was successful!"
        case .failure:
            return "Your request failed!"
        }
    }
    
    @ViewBuilder
    var customButton: some View {
        switch self {
        case .success:
            Button("Success") {
                
            }
        case .failure:
            Button("Failure") {
                
            }
        }
    }
}

extension View {
    func alertObject(_ alertObject: AlertObject) -> Self {
        self
           
    }
}

struct ContentView: View {
    @State var isPresented: Bool = false
    @State var alertObject = AlertObject(title: "Alert title", message: "This is a message.!")
    @State var alertComponent: AlertComponent? = .success
    
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
        .alert(alertComponent?.title ?? "", isPresented: $isPresented, actions: {
            Button("OK") {
                
            }
        }, message: {
            Text(alertComponent?.message ?? "")
        })
    }
}

#Preview {
    ContentView()
}
