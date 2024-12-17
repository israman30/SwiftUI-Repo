//
//  ContentView.swift
//  Alert Component
//
//  Created by Israel Manzo on 12/16/24.
//

import SwiftUI

protocol AlertProtocol {
    var title: String { get }
    var message: String { get }
    var buttons: AnyView { get }
}

struct AlertObject {
    let title: String
    let message: String
}

enum AlertComponent: AlertProtocol {
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
    
    var buttons: AnyView {
        AnyView(getButtons())
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
    func presentAlert<T: AlertProtocol>(_ alert: Binding<T?>, isPresented: Binding<Bool>) -> some View {
        self
            .alert(alert.wrappedValue?.title ?? "", isPresented: isPresented, actions: {
                alert.wrappedValue?.buttons
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
