//
//  AVPlayer+Debugging.swift
//  WallStreaming
//
//  Created by Konrad Feiler on 15.04.18.
//  Copyright © 2018 Konrad Feiler. All rights reserved.
//

import AVFoundation

extension AVPlayerTimeControlStatus: CustomDebugStringConvertible {
    public var debugDescription: String {
        switch self {
        case .paused: return "paused"
        case .playing: return "playing"
        case .waitingToPlayAtSpecifiedRate: return "waitingToPlayAtSpecifiedRate"
        }
    }
}

extension AVPlayerStatus: CustomDebugStringConvertible {
    public var debugDescription: String {
        switch self {
        case .failed: return "failed"
        case .readyToPlay: return "readyToPlay"
        case .unknown: return "unknown"
        }
    }
}
