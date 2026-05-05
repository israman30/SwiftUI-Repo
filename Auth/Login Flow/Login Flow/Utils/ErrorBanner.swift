//
//  ErrorBanner.swift
//  Login Flow
//
//  Created by Israel Manzo on 5/5/26.
//

import SwiftUI

/// Inline banner used to surface validation/network errors in auth screens.
///
/// Typically shown conditionally when a view model provides a non-nil `errorMessage`.
struct ErrorBanner: View {

    let message: String

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: "exclamationmark.circle.fill")
                .foregroundStyle(.red)
                .font(.system(size: 16))

            Text(message)
                .font(.subheadline)
                .foregroundStyle(.red)
                .multilineTextAlignment(.leading)

            Spacer()
        }
        .padding(12)
        .background(Color.red.opacity(0.08))
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.red.opacity(0.2), lineWidth: 0.5)
        )
    }
}

struct ErrorBanner_Previews: PreviewProvider {
    static var previews: some View {
        ErrorBanner(message: "Something went wrong. Please try again.")
            .padding()
    }
}
