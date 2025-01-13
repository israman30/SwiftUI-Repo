//
//  ContentView.swift
//  ScrollView
//
//  Created by Israel Manzo on 1/12/25.
//

import SwiftUI

struct ContentView: View {
    
    @State private var scrollPosition = ScrollPosition()
    @State var visibleColor: [Color] = []
    @State var position: CGFloat = 0
    
    let colors: [Color] = [
        .red, .green, .blue, .yellow, .cyan, .pink, .purple, .gray, .brown, .orange, .indigo, .mint, .primary, .secondary
    ]
    
    var body: some View {
        ZStack(alignment:. bottomTrailing) {
            VStack {
                Text("\(position)")
                ScrollView {
                    VStack(spacing: 24) {
                        ForEach(colors, id: \.self) { color in
                            RoundedRectangle(cornerRadius: 10)
                                .fill(color)
                                .frame(width: 360, height: 240)
                                .cornerRadius(10)
                                .scaleEffect(visibleColor.contains(color) ? 1.0 : 0.8)
                                .opacity(visibleColor.contains(color) ? 1.0 : 0.5)
                                .onScrollVisibilityChange { isVisible in
                                    if isVisible {
                                        print("\(color) is visible")
                                    }
                                }
                        }
                    }
                    .animation(.bouncy, value: visibleColor)
                    .scrollTargetLayout()
                }
                .onScrollTargetVisibilityChange(idType: Color.self, threshold: 0.3, { colors in
                    self.visibleColor = colors
                })
                .onScrollPhaseChange({ oldPhase, newPhase in
                    print("Old phase: \(oldPhase) | new phase: \(newPhase)")
                })
                .onScrollGeometryChange(for: CGFloat.self, of: { geometry in
                    geometry.contentOffset.y
                }, action: { oldValue, newValue in
                    print("old value: \(oldValue), new Y offset value: \(newValue)")
                    self.position = newValue
                })
                .scrollPosition($scrollPosition)
                .animation(.spring, value: scrollPosition)
            }
            
            buttons
        }
//        .defaultScrollAnchor(.bottom)
    }
    
    private var buttons: some View {
        VStack {
            Button {
                scrollPosition.scrollTo(edge: .top)
            } label: {
                Image(systemName: "arrow.up.circle.fill")
                    .resizable()
                    .frame(width: 56, height: 56)
                    .foregroundStyle(.white, .black)
            }
            
            Button {
                scrollPosition.scrollTo(edge: .bottom)
            } label: {
                Image(systemName: "arrow.down.circle.fill")
                    .resizable()
                    .frame(width: 56, height: 56)
                    .foregroundStyle(.white, .black)
            }
            
            Button {
                scrollPosition.scrollTo(id: colors[4])
            } label: {
                Image(systemName: "arrow.up.and.down.circle.fill")
                    .resizable()
                    .frame(width: 56, height: 56)
                    .foregroundStyle(.white, .black)
            }
        }
    }
}

#Preview {
    ContentView()
}
