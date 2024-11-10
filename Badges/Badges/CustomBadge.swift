//
//  CustomBadge.swift
//  Badges
//
//  Created by Israel Manzo on 11/9/24.
//

import SwiftUI

struct CustomBadge: View {
    var body: some View {
        List {
            VStack {
                Image(systemName: "house.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 50)
                Text("Home")
                    .font(.system(size: 15))
            }
            .customBadge(count: 7)
            
            VStack {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 50)
                Text("John Doe")
                    .font(.system(size: 15))
            }
            .customBadge(count: 250)
        }
    }
}

#Preview {
    CustomBadge()
}

struct Badge: ViewModifier {
    let count: Int
    let maxCount: Int
    
    func body(content: Content) -> some View {
        if count > 0 {
            ZStack(alignment: .topTrailing) {
                content
                HStack(spacing: 0) {
                    Text(min(count, maxCount), format: .number)
                    /// `count` is greater than `maxCount` display `count+`
                    if count > maxCount {
                        Text("+")
                    }
                }
                .font(.system(size: 14))
                .foregroundStyle(.white)
                .padding(.horizontal, 5)
                .padding(.vertical, count > 9 ? 7 : 5) /// when the `badge` is a `single digit`, the badge should be close to a circle shape
                .background(.red)
                .frame(height: count > 9 ? 17 : 19)
                .clipShape(Capsule())
            }
        } else {
            content /// else no badge display
        }
    }
}

extension View {
    func customBadge(count: Int = 0, maxCount: Int = 99) -> some View {
        modifier(Badge(count: count, maxCount: maxCount))
    }
}
