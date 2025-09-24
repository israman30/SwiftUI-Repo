//
//  ContentView.swift
//  Container Relative Frame
//
//  Created by Israel Manzo on 9/23/25.
//

import SwiftUI

/**
 The `containerRelativeFrame` modifier we will be looking at in this article, a modifier for sizing a view relative to the nearest container, was actually added from iOS 17(almost 2 years ago?), but I didn’t realize that it exists and started using it until recently!
 
 We can use this modifier to specify the relative size of a view in relation to the size of the nearest container view such as a `VStack`, `HStack`, `ScrollView`, `List`, and etc.
 
 `Multiple Items`
 What if we want multiple cards per page?

 Simply use the containerRelativeFrame(_:count:span:spacing:alignment:) variation to specify

 - count: the total number of views, ie: rows or columns, in the specified axis,
 - span: the number of rows or columns that the modified view should actually occupy
 - spacing: the spacing between each view

 */

struct ContentView: View {
    var body: some View {
        VStack {
            ContainerRelativeFrameDemo()
            ContainerRelativeFrameDemo2()
        }
    }
}

#Preview {
    ContentView()
}

struct ContainerRelativeFrameDemo: View {
    var body: some View {
        ScrollView(.vertical) {
            VStack(spacing: 8) {
                ForEach(0..<10, id: \.self) { index in
                    RoundedRectangle(cornerRadius: 8)
                        .fill(.blue.opacity(0.8))
                        .containerRelativeFrame([.vertical], count: 3, spacing: 24)
                }
            }
            .padding()
        }
    }
}

struct ContainerRelativeFrameDemo2: View {
    var body: some View {
        ScrollView(.vertical) {
            VStack(spacing: 8) {
                ForEach(0..<10, id: \.self) { index in
                    let alignment: (Alignment, String) = switch index % 3 {
                    case 0:
                        (.top, "top")
                    case 1:
                        (.center, "center")
                    default:
                        (.bottom, "bottom")
                    }
                    Text(alignment.1)
                        .containerRelativeFrame([.vertical], alignment: .center) { length, axis in
                            if axis == .horizontal {
                                return length * 0.6
                            } else {
                                return length * 0.5
                            }
                        }
                    RoundedRectangle(cornerRadius: 8)
                        .fill(.black.opacity(0.8))
                        .frame(height: 2)
                }
            }
            .padding()
        }
    }
}
