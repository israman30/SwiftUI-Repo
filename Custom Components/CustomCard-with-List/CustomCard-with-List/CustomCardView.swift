//
//  CustomCardView.swift
//  CustomCard-with-List
//
//  Created by Israel Manzo on 5/17/22.
//

import SwiftUI

struct CustomCardView<T: Identifiable>: View {
    
    var content: T
    
    var body: some View {
        VStack(alignment: .leading) {
            if let image = content as? Image {
//                Image("\(image)")
                Image("\(image)")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
            
            VStack(alignment: .leading) {
                Text("Super Mario Bros.")
                    .font(.title)
                    .fontWeight(.bold)
                Text("Explore the adventure of Mario's world")
                    .foregroundColor(Color(.systemGray))
            }
            .padding(.horizontal)
            .padding(.vertical, 5)
        }
        .background(Color.white)
        .cornerRadius(5)
        .shadow(color: Color.gray, radius: 5, x: 0, y: 2)
        .padding(.bottom, 5)
    }
}

//struct CustomCardView_Previews: PreviewProvider {
//    static var previews: some View {
//        CustomCardView()
//    }
//}
