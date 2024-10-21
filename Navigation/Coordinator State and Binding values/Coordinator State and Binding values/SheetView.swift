//
//  SheetView.swift
//  Coordinator State and Binding values
//
//  Created by Israel Manzo on 10/20/24.
//

import SwiftUI

struct SheetView: View {
    
    @Environment(\.dismiss) var dismiss
    
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
            Text("this is a sheet")
            Spacer()
        }
    }
}

#Preview {
    SheetView()
}
