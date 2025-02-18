//
//  ContentView.swift
//  Alert View Extension
//
//  Created by Israel Manzo on 2/18/25.
//

import SwiftUI

struct ContentView: View {
    @State private var showAlert = false
    @State private var isPresented = false
    @State private var alert: AlertImplementation? = nil
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Prsente First Method!")
                .padding()
                .background(Color.blue)
                .foregroundStyle(.white)
                .onTapGesture {
                    self.showAlert = true
                }
            Text("Prsente Second Method!")
                .padding()
                .background(Color.green)
                .foregroundStyle(.white)
                .onTapGesture {
                    self.isPresented = true
                }
        }
        .padding()
        .presentAlert(isPresented: $showAlert, title: "Some title", messsage: "Some Messaeg", cancelMessage: "Cancel", confirmMessage: "OK") {
            // Action
        } confirmAction: {
            // Action
        }
        .alertPresent($alert,title: "Some message",  isPresented: $isPresented)
        

    }
}

#Preview {
    ContentView()
}

struct AlertView: ViewModifier {
    @Binding var isPresented: Bool
    var title: String
    var message: String
    var cancelMessage: String
    var confirmMessage: String
    var cancelAction: () -> Void
    var confirmAction: () -> Void
    
    func body(content: Content) -> some View {
        content.alert(title, isPresented: $isPresented) {
            Button(cancelMessage, role: .cancel, action: cancelAction)
            Button(action: confirmAction) {
                Text(confirmMessage)
            }
        } message: {
            Text(message)
        }
    }
}

extension View {
    func presentAlert(
        isPresented: Binding<Bool>,
        title: String,
        messsage: String,
        cancelMessage: String,
        confirmMessage: String,
        cacelAction: @escaping () -> Void,
        confirmAction: @escaping () -> Void
    ) -> some View {
        self.modifier(AlertView(
            isPresented: isPresented,
            title: title,
            message: messsage,
            cancelMessage: cancelMessage,
            confirmMessage: confirmMessage,
            cancelAction: cacelAction,
            confirmAction: confirmAction
        ))
    }
}

// MARK: - Second method of reusable alert
protocol AlertProtocol {
    var button: AnyView { get }
}

extension View {
    func alertPresent<T: AlertProtocol>(_ alert: Binding<T?>, title: String = "", message: String = "", isPresented: Binding<Bool>) -> some View {
        self.alert("\(title)\n", isPresented: isPresented, actions: {
            alert.wrappedValue?.button
        }, message: {
            Text(message)
        })
    }
}

enum AlertImplementation: AlertProtocol {
    case actions(cancel: () -> Void)
    case state(state: () -> Void)
    
    var button: AnyView {
        AnyView(setButton())
    }
    
    @ViewBuilder
    func setButton() -> some View {
        switch self {
        case .actions(let cancel):
            Button("Message 1", role: .cancel, action: {
                cancel()
            })
            Button("Cancel", role: .destructive, action: {
                cancel()
            })
        case .state(let state):
            Button("Message 2", action: {
                state()
            })
        }
    }
}
