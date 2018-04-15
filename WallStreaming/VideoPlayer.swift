//
//  VideoPlayer.swift
//  WallStreaming
//
//  Created by Konrad Feiler on 15.04.18.
//  Copyright © 2018 Konrad Feiler. All rights reserved.
//

import SpriteKit
import AVFoundation

class VideoPlayer: NSObject {

    let scene: SKScene
    private let player: AVPlayer
    private let videoNode: SKVideoNode
    private var playerStateObservation: NSKeyValueObservation?
    private var timeControlStateObservation: NSKeyValueObservation?
    private var shouldStartAfterBuffering = false

    private(set) var playerStatus: AVPlayerTimeControlStatus = .paused {
        didSet {
            print("\(oldValue) -> \(playerStatus)")
            if playerStatus == .waitingToPlayAtSpecifiedRate, let reason = player.reasonForWaitingToPlay {
                print("Reason: \( reason )")
            }
        }
    }

    init(streamURL: URL) {
        let playerItem = AVPlayerItem(url: streamURL)
        player = AVPlayer(playerItem: playerItem)
        videoNode = SKVideoNode(avPlayer: player)
        let size = CGSize(width: 1600, height: 900)
        videoNode.size = size
        videoNode.position = CGPoint(x: 0.5 * size.width, y: 0.5 * size.height)

        // for some reason the video is flipped by default
        videoNode.yScale = -1
        scene = SKScene(size: size)
        scene.addChild(videoNode)
        
        super.init()
        
        playerStatus = player.timeControlStatus
        timeControlStateObservation = player.observe(\.timeControlStatus) { (player, _) in
            self.playerStatus = player.timeControlStatus
        }
        playerStateObservation = player.observe(\.status, changeHandler: { (player, change) in
            print("player.status: \(player.status)")
            if player.status == .readyToPlay && self.shouldStartAfterBuffering {
                self.shouldStartAfterBuffering = false
                player.play()
            }
        })
        
        NotificationCenter.default.addObserver(self, selector: #selector(VideoPlayer.playerItemFinished(_:)),
                                               name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
                                               object: nil)
    }
    
    deinit {
        timeControlStateObservation?.invalidate()
        playerStateObservation?.invalidate()
    }
    
    func startAsSoonAsPossible() {
        print("player.status before play: \(player.status)")
        if player.status == .readyToPlay {
            player.play()
        } else {
            shouldStartAfterBuffering = true
        }
    }
    
}

extension VideoPlayer {
    
    @objc
    func playerItemFinished(_ notification: NSNotification) {
        print("Stream finished: \(notification)")

        
    }
}
