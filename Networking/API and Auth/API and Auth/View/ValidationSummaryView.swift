//
//  ValidationSummaryView.swift
//  API and Auth
//
//  Created by Israel Manzo on 9/6/25.
//

import SwiftUI

struct ValidationSummaryView: View {
    
    let errors: [String]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ForEach(errors, id: \.self) { error in
                HStack(alignment: .top) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundStyle(.red)
                    Text(error)
                        .foregroundStyle(.red)
                        .font(.subheadline)
                        .multilineTextAlignment(.leading)
                }
            }
        }
        .padding()
        .background(Color.red.opacity(0.05))
        .cornerRadius(8)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    ValidationSummaryView(errors: [
        "Name can not be empty.",
        "Password must be at least 8 characters long.",
        "Email format is invalid."
    ])
}
