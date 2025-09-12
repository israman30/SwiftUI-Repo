//
//  ContentView.swift
//  CustomCardsLikeAppStore
//
//  Created by Israel Manzo on 5/15/22.
//

import SwiftUI
import Cards

struct ContentView: View {
    var body: some View {
        VStack {
            CustomCardView()
                .frame(width: 200, height: 200)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct CustomCardView: UIViewRepresentable {
    
    func makeUIView(context: Context) -> CardHighlight {
        let card = CardHighlight(frame: .zero)
        card.icon = UIImage(named: "icon")
        card.backgroundImage = UIImage(named: "background")
        card.title = "Super Mario World"
        card.itemTitle = "Mario"
        card.itemSubtitle = "Super mario wordl"
        card.buttonText = "GET"
        card.titleSize = 25
        
        return card
    }
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
}

class NewView: UIViewController {
    
}
