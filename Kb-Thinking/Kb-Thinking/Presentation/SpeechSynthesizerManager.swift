//
//  SpeechSynthesizerManager.swift
//  Kb-Thinking
//
//  Created by jeonguk29 on 8/6/25.
//

import Foundation
import AVFoundation

class SpeechSynthesizerManager {
    private let synthesizer = AVSpeechSynthesizer()

    /// 음성 합성: 한국어 자연스러운 목소리로 읽기
    func speak(text: String,
               voiceIdentifier: String = "com.apple.ttsbundle.Yuna-compact",
               rate: Float = 0.5,
               pitch: Float = 1.0,
               volume: Float = 1.0) {

        guard !text.isEmpty else {
            print("❗ 읽을 텍스트가 없습니다.")
            return
        }

        // 이미 말하고 있다면 중단 후 새로 시작
        if synthesizer.isSpeaking {
            synthesizer.stopSpeaking(at: .immediate)
        }

        let utterance = AVSpeechUtterance(string: text)

        // 설정된 voice identifier 사용
        if let voice = AVSpeechSynthesisVoice(identifier: voiceIdentifier) {
            utterance.voice = voice
        } else {
            print("❗ 해당 identifier로 음성을 찾을 수 없습니다. 기본 한국어로 재생합니다.")
            utterance.voice = AVSpeechSynthesisVoice(language: "ko-KR")
        }

        // 속도, 음높이, 볼륨 설정
        utterance.rate = rate           // 기본: 0.5 (0.1 ~ 1.0)
        utterance.pitchMultiplier = pitch   // 기본: 1.0
        utterance.volume = volume       // 기본: 1.0

        synthesizer.speak(utterance)
    }

    func stop() {
        synthesizer.stopSpeaking(at: .immediate)
    }
}
