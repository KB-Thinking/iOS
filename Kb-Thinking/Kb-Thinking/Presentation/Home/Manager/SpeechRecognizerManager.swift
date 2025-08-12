//
//  SpeechRecognizerManager.swift
//  Kb-Thinking
//
//  Created by jeonguk29 on 8/6/25.
//

import Foundation
import SwiftUI
import Speech
import AVFoundation

final class SpeechRecognizerManager: NSObject, ObservableObject {

    // MARK: - Private
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "ko-KR"))
    private let audioEngine = AVAudioEngine()
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?

    // MARK: - Published
    @Published var recognizedText: String = ""
    @Published private(set) var isRecording: Bool = false
    @Published var isAuthorized: Bool = false

    // MARK: - Lifecycle
    override init() {
        super.init()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleInterruption(_:)),
            name: AVAudioSession.interruptionNotification,
            object: AVAudioSession.sharedInstance()
        )
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
        stopRecording()
    }

    // MARK: - Authorization
    func requestAuthorization(completion: @escaping (Bool) -> Void) {
        SFSpeechRecognizer.requestAuthorization { [weak self] status in
            DispatchQueue.main.async {
                self?.isAuthorized = (status == .authorized)
                completion(status == .authorized)
            }
        }
    }

    // MARK: - Recording
    func startRecording() throws {
        guard !audioEngine.isRunning, !isRecording else { return }
        guard isAuthorized else {
            throw NSError(domain: "SpeechRecognizerUnauthorized", code: -11, userInfo: [NSLocalizedDescriptionKey: "음성 인식 권한이 없습니다."])
        }
        guard let recognizer = speechRecognizer, recognizer.isAvailable else {
            throw NSError(domain: "SpeechRecognizerUnavailable", code: -10, userInfo: [NSLocalizedDescriptionKey: "음성 인식기를 사용할 수 없습니다."])
        }

        // 오디오 세션 설정 - 더 안정적인 옵션
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(.record, mode: .measurement, options: [])
            try session.setActive(true, options: [])
        } catch {
            throw NSError(domain: "AudioSessionError", code: -12, userInfo: [NSLocalizedDescriptionKey: "오디오 세션 설정 실패: \(error.localizedDescription)"])
        }

        // 인식 요청 설정
        let request = SFSpeechAudioBufferRecognitionRequest()
        request.shouldReportPartialResults = true
        recognitionRequest = request

        let inputNode = audioEngine.inputNode
        let format = inputNode.outputFormat(forBus: 0)

        inputNode.removeTap(onBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: format) { [weak self] buffer, _ in
            self?.recognitionRequest?.append(buffer)
        }

        // 인식 작업 시작
        recognitionTask = recognizer.recognitionTask(with: request) { [weak self] result, error in
            guard let self else { return }

            if let result = result {
                let text = result.bestTranscription.formattedString
                DispatchQueue.main.async { 
                    self.recognizedText = text
                }
            }

            if let error = error {
                // 정상적인 취소는 에러로 표시하지 않음
                let nsError = error as NSError
                if nsError.domain == "kAFAssistantErrorDomain" && nsError.code == 216 {
                    // "Recognition request was canceled" - 정상적인 중지
                    print("🎤 녹음 중지됨")
                } else if nsError.domain == "kAFAssistantErrorDomain" && nsError.code == 1101 {
                    // 로컬 음성 인식 서비스 오류
                    print("🎤 로컬 음성 인식 서비스 오류")
                } else if nsError.domain == "kAFAssistantErrorDomain" && nsError.code == 203 {
                    // "No speech detected" - 음성 감지 안됨
                    print("🎤 음성이 감지되지 않음")
                } else {
                    // 기타 실제 에러만 표시
                    print("🎤 인식 에러:", error.localizedDescription)
                }
                // 에러가 발생해도 현재까지 인식된 텍스트는 유지
            }
        }

        // 오디오 엔진 시작
        audioEngine.prepare()
        try audioEngine.start()
        isRecording = true
    }

    func stopRecording() {
        guard isRecording || audioEngine.isRunning || recognitionTask != nil else { return }

        // 먼저 상태 업데이트
        isRecording = false

        // 인식 작업 정리 (에러 메시지 방지를 위해 먼저 취소)
        recognitionTask?.cancel()
        recognitionTask = nil
        
        // 오디오 엔진 정리
        if audioEngine.isRunning {
            audioEngine.stop()
        }
        
        let inputNode = audioEngine.inputNode
        inputNode.removeTap(onBus: 0)

        // 요청 정리
        recognitionRequest?.endAudio()
        recognitionRequest = nil

        // 세션 비활성화 - 더 안전하게
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            do {
                let session = AVAudioSession.sharedInstance()
                if session.isOtherAudioPlaying {
                    try session.setActive(false, options: [.notifyOthersOnDeactivation])
                }
            } catch {
                print("🔇 녹음 세션 비활성화 실패:", error.localizedDescription)
            }
        }
    }

    func cancel() {
        stopRecording()
        DispatchQueue.main.async { [weak self] in
            self?.recognizedText = ""
        }
    }

    // MARK: - Interruptions
    @objc private func handleInterruption(_ notification: Notification) {
        guard
            let info = notification.userInfo,
            let typeValue = info[AVAudioSessionInterruptionTypeKey] as? UInt,
            let type = AVAudioSession.InterruptionType(rawValue: typeValue)
        else { return }

        if type == .began {
            stopRecording()
        }
    }
}
