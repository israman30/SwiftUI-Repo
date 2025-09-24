//
//  ContentView.swift
//  Container Relative Frame
//
//  Created by Israel Manzo on 9/23/25.
//

import SwiftUI

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
