//
//  ContentView.swift
//  View Modifiers
//
//  Created by Israel Manzo on 11/12/24.
//

import SwiftUI

struct ContentView: View {
    @State var isActive = false
    @State var isDone = false
    @State var isPresented = false
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
                .heading1()
            
            VStack {
                Text("Card Shadow")
                    .font(.title2)
            }
            .padding()
            .background(Color.yellow)
            .cardShadow()
            
            VStack {
                Text("Align Modifier")
                    .font(.title2)
                    .fullWidth()
            }
            .padding()
            .background(Color.yellow)
            .cardShadow()
            
            Text("Condition")
                .if(isActive) { content in
                    content
                        .background(Color.red)
                }
            
            Text("New task")
                .font(.title2)
                .if(isDone) { content in
                    content
                        .strikethrough()
                }
            Button {
                self.isPresented.toggle()
            } label: {
                Text("POP UP")
                    .padding(.horizontal)
            }
            .buttonStyle(.borderedProminent)
            .popUp(isPresented: $isPresented) {
                VStack {
                    Text("Card")
                    Text("Content of the card as body for testing..")
                }
                .padding()
            }
            
            VStack {
                Text("Animation")
            }
            .clipShape(Capsule())
            .padding()
            .background(Color.yellow)
//            .pulseAnimation()
            
            Button {
                
            } label: {
                Text("Button Style")
            }
            .buttonStyle(.shadow)
            
            LabelView(text: "Some Label")
                .padding(.vertical)
            
            CustomLabelView(
                TextLabelViewContentView(
                    text: "Another label"
                )
            )
            
            CustomLabelView(
                TextIconLeftLabelView(
                    text: "10 min running",
                    icon: Image(systemName: "figure.walk")
                )
            )
            
            CustomLabelView(
                TextWithLeftRightIconContent(
                    text: "10 min running",
                    leftIcon: Image(systemName: "figure.walk"),
                    rightIcon: Image(systemName: "10.circle")
                )
            )
            
            CustomLabelView(
                text: "10 min running",
                leftIcon: Image(systemName: "figure.walk"),
                rightIcon: Image(systemName: "10.circle")
            )

            // or

            CustomLabelView(
                .textWithLeftRightIcon(
                    text: "10 min running",
                    leftIcon: Image(systemName: "figure.walk"),
                    rightIcon: Image(systemName: "10.circle")
                )
            )
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
