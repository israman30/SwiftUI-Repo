//
//  CustomImageCard.swift
//  Image Display Card
//
//  Created by Israel Manzo on 12/18/23.
//

import SwiftUI

struct CustomImageCard: View {
    
    var customImage: String?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Image(customImage ?? "No image")
                .resizable()
                .frame(width: 200, height: 250)
            bodyText
                .padding(.horizontal, 8)
        }
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .shadow(radius: 8)
    }
    
    var bodyText: some View {
        VStack(alignment: .leading) {
            Text("Card title goes here")
                .font(.headline)
            HStack {
                Image(systemName: "clock")
                Text("Time is going")
            }
            .foregroundStyle(Color.gray)
            .padding(.bottom, 16)
        }
    }
}

#Preview {
    CustomImageCard(customImage: "ronaldo")
}
