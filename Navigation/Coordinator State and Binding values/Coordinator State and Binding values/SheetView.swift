//
//  SheetView.swift
//  Coordinator State and Binding values
//
//  Created by Israel Manzo on 10/20/24.
//

import SwiftUI

struct SheetView: View {
    
    @Environment(\.dismiss) var dismiss
    @State var userActivity: Bool = false
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title)
                        .padding()
                }
                
            }
            Spacer()
            HStack {
                Circle()
                    .frame(width: 30, height: 30)
                    .foregroundColor(userActivity ? .green : .red)
                Text("User activity is \(userActivity ? "active" : "not active")")
                    .font(.title)
            }
            Text("this is a sheet")
            Spacer()
        }
    }
}

#Preview {
    SheetView()
}
