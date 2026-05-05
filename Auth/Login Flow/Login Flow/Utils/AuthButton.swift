//
//  AuthButton.swift
//  Login Flow
//
//  Created by Israel Manzo on 5/5/26.
//

import SwiftUI

/// Primary call-to-action button used across the auth flow.
///
/// Displays a loading spinner when `isLoading == true` and disables itself when either
/// loading or `isEnabled == false`.
struct AuthButton: View {
    let title: String
    let isLoading: Bool
    let isEnabled: Bool
    let action: () -> Void
    var body: some View {
        Button(action: action) {
            ZStack {
                RoundedRectangle(cornerRadius: 14)
                    .fill(isEnabled ? Color.blue : Color(.systemGray4))
                
                if isLoading {
                    ProgressView()
                        .tint(.white)
                } else {
                    Text(title)
                        .font(.headline)
                        .foregroundStyle(.white)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 52)
        }
        .disabled(!isEnabled || isLoading)
        .animation(.easeInOut(duration: 0.2), value: isEnabled)
        .animation(.easeInOut(duration: 0.2), value: isLoading)
    }
}

struct AuthButton_Previews: PreviewProvider {
    static var previews: some View {
        AuthButton(title: "Continue", isLoading: false, isEnabled: true) {}
            .padding()
    }
}
