//
//  SpeechSynthesizerManager.swift
//  Kb-Thinking
//
//  Created by jeonguk29 on 8/6/25.
//

import Foundation
import AVFoundation
import Combine

// OpenAI TTS 연동 옵션
enum TTSEngineType {
    case system
    case openAI
}

final class SpeechSynthesizerManager: NSObject {

    private let synthesizer = AVSpeechSynthesizer()
    @Published var isSpeaking: Bool = false

    // OpenAI 옵션
    private let ttsEngine: TTSEngineType
    private let openAIService: OpenAITTSAPIServiceProtocol?
    private let openAIPlayer = OpenAITTSPlayer()

    init(ttsEngine: TTSEngineType = .system, openAIService: OpenAITTSAPIServiceProtocol? = nil) {
        self.ttsEngine = ttsEngine
        self.openAIService = openAIService
        super.init()
        synthesizer.delegate = self
    }

    func speak(text: String) {
        guard !text.isEmpty else { return }

        switch ttsEngine {
        case .system:
            speakWithSystem(text: text)
        case .openAI:
            Task { await speakWithOpenAI(text: text) }
        }
    }

    private func speakWithSystem(text: String) {
        if synthesizer.isSpeaking {
            synthesizer.stopSpeaking(at: .immediate)
            isSpeaking = false
        }
        activatePlaybackSession()
        let utterance = AVSpeechUtterance(string: text)
        if let voice = AVSpeechSynthesisVoice(language: "ko-KR") {
            utterance.voice = voice
        }
        utterance.rate = 0.45
        utterance.pitchMultiplier = 1.1
        utterance.volume = 0.9
        utterance.preUtteranceDelay = 0.1
        utterance.postUtteranceDelay = 0.2
        synthesizer.speak(utterance)
        isSpeaking = true
    }

    private func speakWithOpenAI(text: String) async {
        guard let service = openAIService else {
            // fallback
            speakWithSystem(text: text)
            return
        }
        do {
            let data = try await service.synthesize(text: text, model: "gpt-4o-mini-tts", voice: "alloy", format: "mp3")
            try openAIPlayer.play(data: data, fileTypeHint: .mp3)
        } catch {
            print("OpenAI TTS 실패: \(error.localizedDescription)")
            // 실패 시 시스템 합성으로 폴백
            speakWithSystem(text: text)
        }
    }

    func stop() {
        synthesizer.stopSpeaking(at: .immediate)
        isSpeaking = false
        deactivateSession()
        openAIPlayer.stop()
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
