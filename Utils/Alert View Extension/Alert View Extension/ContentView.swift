//
//  ContentView.swift
//  Alert View Extension
//
//  Created by Israel Manzo on 2/18/25.
//

import SwiftUI

struct ContentView: View {
    @State private var showAlert = false
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
                .padding()
                .background(Color.blue)
                .foregroundStyle(.white)
                .onTapGesture {
                    self.showAlert = true
                }
        }
        .padding()
        .presentAlert(isPresented: $showAlert, title: "Some title", messsage: "Some Messaeg", cancelMessage: "Cancel", confirmMessage: "OK") {
            // Action
        } confirmAction: {
            // Action
        }

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
