//
//  SheetView.swift
//  Coordinator State and Binding values
//
//  Created by Israel Manzo on 10/20/24.
//

import SwiftUI

struct SheetView: View {
    
    @Environment(\.dismiss) var dismiss
    var myViewModel: MyViewModel
    
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
                    .foregroundColor(myViewModel.userActivity ? .green : .red)
                Text(myViewModel.userActivity ? "\(myViewModel.username) is logged in" : "\(myViewModel.username) is logged out")
                    .font(.title)
            }
            Text("this is a sheet")
            Text(myViewModel.text)
            Spacer()
        }
    }
}

#Preview {
    SheetView(myViewModel: .init())
}
