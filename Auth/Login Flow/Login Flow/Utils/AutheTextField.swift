//
//  AutheTextField.swift
//  Login Flow
//
//  Created by Israel Manzo on 5/5/26.
//

import SwiftUI
// MARK: - Auth Text Field

/// Reusable text field used across auth screens.
///
/// ## Features
/// - Optional secure entry with an “eye” reveal toggle.
/// - Supports keyboard type, text content type, and submit behavior.
///
/// ## Usage
/// ```swift
/// AuthTextField(
///   title: "Email",
///   placeholder: "you@example.com",
///   text: $viewModel.email,
///   keyboardType: .emailAddress,
///   contentType: .emailAddress,
///   submitLabel: .next
/// ) { focusedField = .password }
/// ```
struct AuthTextField: View {

    let title: String
    let placeholder: String
    @Binding var text: String
    var isSecure: Bool = false
    var keyboardType: UIKeyboardType = .default
    var contentType: UITextContentType? = nil
    var submitLabel: SubmitLabel = .done
    var onSubmit: () -> Void = {}

    @State private var isRevealed = false

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.subheadline.weight(.medium))
                .foregroundStyle(.primary)

            HStack {
                Group {
                    if isSecure && !isRevealed {
                        SecureField(placeholder, text: $text)
                    } else {
                        TextField(placeholder, text: $text)
                            .keyboardType(keyboardType)
                            .autocorrectionDisabled()
                            .textInputAutocapitalization(
                                keyboardType == .emailAddress ? .never : .words
                            )
                    }
                }
                .textContentType(contentType)
                .submitLabel(submitLabel)
                .onSubmit(onSubmit)

                if isSecure {
                    Button {
                        isRevealed.toggle()
                    } label: {
                        Image(systemName: isRevealed ? "eye.slash" : "eye")
                            .foregroundStyle(.secondary)
                            .font(.system(size: 16))
                    }
                }
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 12)
            .background(Color(.secondarySystemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color(.separator), lineWidth: 0.5)
            )
        }
    }
}

struct AuthTextField_Previews: PreviewProvider {
    static var previews: some View {
        AuthTextField(
            title: "Email",
            placeholder: "you@example.com",
            text: .constant(""),
            keyboardType: .emailAddress,
            contentType: .emailAddress,
            submitLabel: .next
        )
        .padding()
    }
}
