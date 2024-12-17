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
    case success(_ okAction: () -> Void?, cancel: () -> Void?)
    case failure(_ failure: () -> Void?)
    
    var title: String {
        switch self {
        case .success:
            return "Ok!"
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
    func getButtons() -> some View {
        switch self {
        case .success(let okAction, let cancel):
            Button("Success") {
                okAction()
            }
            Button("Cancel") {
                cancel()
            }
        case .failure(let failure):
            Button("Failure") {
                failure()
            }
        }
    }
}

extension View {
    func presentAlert(_ alert: Binding<AlertComponent?>, isPresented: Binding<Bool>) -> some View {
        self
            .alert(alert.wrappedValue?.title ?? "", isPresented: isPresented, actions: {
                alert.wrappedValue?.getButtons()
            }, message: {
                Text(alert.wrappedValue?.message ?? "")
            })
    }
}

struct ContentView: View {
    @State var isPresented: Bool = false
    @State var alertObject = AlertObject(title: "Alert title", message: "This is a message.!")
    @State var alertComponent: AlertComponent? = nil
    
    var body: some View {
        VStack {
            Text("Alert Custom Component!")
                .font(.title2)
            Button("Show Alert") {
                showAlert()
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .presentAlert($alertComponent, isPresented: $isPresented)
    }
    
    private func showAlert() {
        self.isPresented.toggle()
        alertComponent = .success({
            // action
        }, cancel: {
            // action
        })
    }
}

#Preview {
    ContentView()
}
