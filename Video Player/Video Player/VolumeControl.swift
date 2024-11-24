//
//  VolumeControl.swift
//  Video Player
//
//  Created by Israel Manzo on 11/23/24.
//

import SwiftUI

struct VolumeControl: View {
    @Binding var volume: CGFloat
    
    var body: some View {
        VStack(spacing: 12) {
            ZStack {
                // for the gray outline
                TriangleShape()
                    .stroke(.gray.opacity(0.7), lineWidth: 2)
                    .frame(width: 100, height: 40)
                    .presentationCornerRadius(3)
                // color gradient
                Rectangle()
                    .fill(LinearGradient(colors: [Color.red, Color.orange, Color.yellow], startPoint: .leading, endPoint: .trailing))
                    .frame(width: 100, height: 40)
                    .mask {
                        Rectangle()
                            .frame(width: volume)
                            .padding(.trailing, 100 - volume)
                    }
                    .mask {
                        TriangleShape()
                            .frame(width: 100, height: 40)
                    }
                    .gesture(DragGesture()
                        .onEnded({ value in
                            var vol = volume + value.translation.width
                            if vol < 0{
                                vol = 0
                            }else if vol > 100{
                                vol = 100
                            }
                            volume = vol
                        })
                    )
            }
            Text("\(String(format: "%.2f", volume))%")
                .font(.system(size: 12))
        }
    }
}

#Preview {
    VolumeControl(volume: .constant(80))
}
