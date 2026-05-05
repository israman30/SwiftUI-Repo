//
//  PasswordStrengthView.swift
//  Login Flow
//
//  Created by Israel Manzo on 5/5/26.
//

import SwiftUI

/// Visual indicator for password quality based on a `PasswordStrength` value.
///
/// ## Usage
/// Used by `SignUpView` to provide immediate feedback while the user creates a password:
/// `PasswordStrengthView(strength: viewModel.passwordStrength)`.
struct PasswordStrengthView: View {
    
    let strength: PasswordStrength
    
    private var color: Color {
        switch strength {
        case .weak:       return .red
        case .fair:       return .orange
        case .strong:     return .blue
        case .veryStrong: return .green
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 4) {
                ForEach(1...4, id: \.self) { step in
                    RoundedRectangle(cornerRadius: 2)
                        .fill(step <= strength.rawValue ? color : Color(.systemGray5))
                        .frame(height: 4)
                        .animation(.easeInOut(duration: 0.25), value: strength)
                }
            }
            
            Text(strength.label)
                .font(.caption)
                .foregroundStyle(color)
                .animation(.easeInOut, value: strength)
        }
    }
}

struct PasswordStrengthView_Previews: PreviewProvider {
    static var previews: some View {
        PasswordStrengthView(strength: .fair)
            .padding()
    }
}
