//
//  ViewPlayerViewModel.swift
//  Video Player
//
//  Created by Israel Manzo on 11/23/24.
//

import AVFoundation
import SwiftUI

class ViewPlayerViewModel: ObservableObject {
    @Published var player: AVPlayer?
    @Published var isPlaying: Bool = false
    
    init(videoURL: URL) {
        let asset = AVURLAsset(url: videoURL)
        let plr = AVPlayer(playerItem: AVPlayerItem(asset: asset))
        self.player = plr
    }
    
    func changeTime(time: Double) {
        let currentTime = player?.currentTime()
        player?.seek(to: CMTime(seconds: (currentTime?.seconds ?? 0) + time, preferredTimescale: 600))
    }
    
    func playVideo() {
        player?.play()
        isPlaying = true
    }
    
    func pauseVideo() {
        player?.pause()
        isPlaying = false
    }
}

class VideoPlayerLayerViewModel: ObservableObject{
    var videoName: String
    @Published var volume: CGFloat = 50
    
    init(videoURL: URL) {
        self.videoName = videoURL.lastPathComponent
    }
}
