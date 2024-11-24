//
//  ContentView.swift
//  Video Player
//
//  Created by Israel Manzo on 11/23/24.
//

import SwiftUI
import AVFoundation

struct ContentView: View {
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}

struct ViewPlayerLayer: View {
    
    @ObservedObject var viewModel: ViewPlayerViewModel
    
    var body: some View {
        VStack {
            // my video layer view.
            AVPlayerLayerView(player: viewModel.player!)
                .frame(height: 300)
            // playback buttons.
            seekPlayer
        }
    }
    
    @ViewBuilder
    var seekPlayer: some View {
        HStack(spacing: 5) {
            // jump back 10 seconds
            Button {
                viewModel.changeTime(time: -10)
            } label: {
                HStack(spacing: 0) {
                    Image(systemName: "chevron.left.2")
                        .foregroundStyle(.white)
                }
            }
            // jump back 5 seconds
            Button {
                viewModel.changeTime(time: -5)
            } label: {
                HStack(spacing: 0) {
                    Image(systemName: "chevron.left")
                        .foregroundStyle(.white)
                }
            }
            // pause or play the video
            Button {
                if viewModel.isPlaying {
                    viewModel.pauseVideo()
                } else {
                    viewModel.playVideo()
                }
            } label: {
                HStack(spacing: 0) {
                    Image(systemName: viewModel.isPlaying ? "square.fill" : "play.fill")
                        .font(.system(size: 20))
                        .foregroundStyle(.white)
                }
            }
            // jump 5 seconds ahead
            Button {
                viewModel.changeTime(time: 5)
            } label: {
                HStack(spacing: 0) {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 20))
                        .foregroundStyle(.white)
                }
            }
            // jump 10 seconds ahead.
            Button {
                viewModel.changeTime(time: 10)
            } label: {
                HStack(spacing: 0) {
                    Image(systemName: "chevron.right.2")
                        .font(.system(size: 20))
                        .foregroundStyle(.white)
                }
            }
        }
    }
}


// Custom Volume slider
struct TriangleShape: Shape{
    var r: CGFloat = 1.5
    nonisolated func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let w = rect.maxX
        let h = rect.maxY
        
        path.move(to: CGPoint(x: r, y: h))
        path.addQuadCurve(to: CGPoint(x: r, y: h - 1.5*r), control: CGPoint(x: 0, y: h))
        path.addLine(to: CGPoint(x: w - 1.5*r, y: 0.7 * r))
        path.addQuadCurve(to: CGPoint(x: w, y: r), control: CGPoint(x: w, y: 0))
        path.addLine(to: CGPoint(x: w, y: h - r))
        path.addQuadCurve(to: CGPoint(x: w - r, y: h), control: CGPoint(x: w, y: h))
        path.closeSubpath()
        
        return path
    }
    
}
