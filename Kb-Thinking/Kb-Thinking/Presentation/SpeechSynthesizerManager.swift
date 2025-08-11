//
//  SpeechSynthesizerManager.swift
//  Kb-Thinking
//
//  Created by jeonguk29 on 8/6/25.
//

import Foundation
import AVFoundation
import Combine

final class SpeechSynthesizerManager: NSObject {

    private let synthesizer = AVSpeechSynthesizer()
    @Published var isSpeaking: Bool = false

    override init() {
        super.init()
        synthesizer.delegate = self
    }

    func speak(text: String) {
        guard !text.isEmpty else { return }

        // 현재 말하고 있으면 즉시 중단
        if synthesizer.isSpeaking {
            synthesizer.stopSpeaking(at: .immediate)
            isSpeaking = false
        }

        // 오디오 세션 활성화
        activatePlaybackSession()

        let utterance = AVSpeechUtterance(string: text)
        
        // 한국어 보이스 설정
        if let voice = AVSpeechSynthesisVoice(language: "ko-KR") {
            utterance.voice = voice
        }

        // 한국어에 최적화된 설정
        utterance.rate = 0.45
        utterance.pitchMultiplier = 1.1
        utterance.volume = 0.9
        utterance.preUtteranceDelay = 0.1
        utterance.postUtteranceDelay = 0.2

        synthesizer.speak(utterance)
        isSpeaking = true
    }

    func stop() {
        synthesizer.stopSpeaking(at: .immediate)
        isSpeaking = false
        deactivateSession()
    }

    // MARK: - Private

    private func activatePlaybackSession() {
        do {
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(.playback, mode: .default, options: [])
            try session.setActive(true, options: [])
        } catch {
            print("🔊 오디오 세션 활성화 실패:", error.localizedDescription)
        }
    }

    private func deactivateSession() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            do {
                let session = AVAudioSession.sharedInstance()
                if session.isOtherAudioPlaying {
                    try session.setActive(false, options: [.notifyOthersOnDeactivation])
                }
            } catch {
                print("🔇 오디오 세션 비활성화 실패:", error.localizedDescription)
            }
        }
    }
}

// MARK: - AVSpeechSynthesizerDelegate
extension SpeechSynthesizerManager: AVSpeechSynthesizerDelegate {
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        isSpeaking = false
        deactivateSession()
    }

    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didCancel utterance: AVSpeechUtterance) {
        isSpeaking = false
        deactivateSession()
    }

    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
        isSpeaking = true
    }
}
