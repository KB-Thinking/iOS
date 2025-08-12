//
//  OpenAITTSPlayer.swift
//  Kb-Thinking
//
//  Created by GPT on 2025-08-11.
//

import Foundation
import AVFoundation

final class OpenAITTSPlayer: NSObject, AVAudioPlayerDelegate {
    private var player: AVAudioPlayer?

    func play(data: Data, fileTypeHint: AVFileType = .mp3) throws {
        try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
        try AVAudioSession.sharedInstance().setActive(true, options: [])

        player = try AVAudioPlayer(data: data, fileTypeHint: fileTypeHint.rawValue)
        player?.delegate = self
        player?.prepareToPlay()
        player?.play()
    }

    func stop() {
        player?.stop()
        player = nil
        try? AVAudioSession.sharedInstance().setActive(false, options: [.notifyOthersOnDeactivation])
    }

    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        try? AVAudioSession.sharedInstance().setActive(false, options: [.notifyOthersOnDeactivation])
    }
} 