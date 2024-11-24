//
//  VideoPlayerView.swift
//  Video Player
//
//  Created by Israel Manzo on 11/23/24.
//

import AVFoundation
import SwiftUI

class VideoPlayerView: UIView {
    override class var layerClass: AnyClass {
        AVPlayerLayer.self
    }
    
    private var playerLayer: AVPlayerLayer? {
        layer as? AVPlayerLayer
    }
    
    var player: AVPlayer? {
        get {
            playerLayer?.player
        }
        set {
            playerLayer?.player = newValue
        }
    }
}

struct AVPlayerLayerView: UIViewRepresentable {
    let player: AVPlayer
    
    func makeUIView(context: Context) -> VideoPlayerView {
        let view = VideoPlayerView()
        view.player = player
        return view
    }
    
    func updateUIView(_ uiView: VideoPlayerView, context: Context) {
        
    }
}
