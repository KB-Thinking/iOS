//
//  VoiceConversationViewModel.swift
//  Kb-Thinking
//
//  Created by jeonguk29 on 8/8/25.
//

import Foundation
import SwiftUI
import Combine

@MainActor
final class VoiceConversationViewModel: ObservableObject {

    // MARK: - Published
    @Published var transcribedText: String = ""
    @Published var llmResponse: String = ""
    @Published var voiceState: VoiceState = .idle
    @Published var isListening: Bool = false
    @Published var isProcessing: Bool = false
    @Published var isAuthorized: Bool = false

    /// 화면(Presentation)으로 라우팅 신호 전달
    var onRoute: ((AppRoute?) -> Void)?

    // MARK: - Dependencies
    private let recognizer = SpeechRecognizerManager()
    private let synthesizer: SpeechSynthesizerManager
    private let sendLLMMessageUseCase: SendLLMMessageUseCase

    // MARK: - State
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Lifecycle
    init(
        sendLLMMessageUseCase: SendLLMMessageUseCase,
        synthesizer: SpeechSynthesizerManager? = nil,
        isPreview: Bool = false
    ) {
        self.sendLLMMessageUseCase = sendLLMMessageUseCase
        self.synthesizer = synthesizer ?? VoiceConversationViewModel.makeDefaultSynthesizer()
        setupBindings()
        
        if !isPreview {
            requestPermissions()
        } else {
            isAuthorized = true
        }
    }

    // MARK: - Factory
    private static func makeDefaultSynthesizer() -> SpeechSynthesizerManager {
        // 1) 런타임 환경변수 (시뮬레이터/개발용)
        if let key = ProcessInfo.processInfo.environment["OPENAI_API_KEY"], !key.isEmpty {
            let service = OpenAITTSAPIService(apiKey: key)
            return SpeechSynthesizerManager(ttsEngine: .openAI, openAIService: service)
        }
        // 2) Info.plist (배포/디바이스용)
        if let key = Bundle.main.object(forInfoDictionaryKey: "OPENAI_API_KEY") as? String, !key.isEmpty {
            let service = OpenAITTSAPIService(apiKey: key)
            return SpeechSynthesizerManager(ttsEngine: .openAI, openAIService: service)
        }
        // 3) 기본: 시스템 TTS
        return SpeechSynthesizerManager(ttsEngine: .system)
    }

    // MARK: - Setup
    private func setupBindings() {
        // 음성 인식 텍스트를 UI 바인딩
        recognizer.$recognizedText
            .receive(on: DispatchQueue.main)
            .assign(to: &$transcribedText)
        
        // 음성 인식 상태 바인딩
        recognizer.$isRecording
            .receive(on: DispatchQueue.main)
            .assign(to: &$isListening)
        
        // 권한 상태 바인딩
        recognizer.$isAuthorized
            .receive(on: DispatchQueue.main)
            .assign(to: &$isAuthorized)
        
        // 음성 합성 완료 감지
        synthesizer.$isSpeaking
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isSpeaking in
                if !isSpeaking && self?.voiceState == .aiSpeaking {
                    // AI 응답 완료 후 자동으로 idle 상태로 전환
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self?.voiceState = .idle
                    }
                }
            }
            .store(in: &cancellables)
    }
    
    private func requestPermissions() {
        // 프리뷰/스냅샷에서는 바로 authorized 처리
        if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1" {
            self.isAuthorized = true
            return
        }
        recognizer.requestAuthorization { [weak self] ok in
            self?.isAuthorized = ok
        }
    }


    // MARK: - Public API (View에서 호출)

    /// 녹음 시작/중지
    func toggleRecording() {
        if isListening {
            stopRecording()
        } else {
            startListening()
        }
    }

    /// 녹음 시작
    func startListening() {
        // 혹시 TTS 중이면 즉시 중단
        if synthesizer.isSpeaking { 
            synthesizer.stop() 
        }
        
        voiceState = .userSpeaking

        do {
            try recognizer.startRecording()
        } catch {
            voiceState = .idle
            print("🎤 음성 인식 시작 실패:", error.localizedDescription)
            // 프리뷰 모드에서는 에러를 무시하고 계속 진행
        }
    }

    /// AI에 메시지 전송
    func sendToLLM() async {
        guard !isProcessing else { return }
        isProcessing = true
        defer { isProcessing = false }

        // 전송 시 녹음 중지 및 초기화
        if isListening {
            stopRecording()
        }

        let input = transcribedText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !input.isEmpty else {
            print("음성 인식 결과가 비어 있습니다.")
            return
        }

        voiceState = .aiSpeaking
        do {
            let entity = try await sendLLMMessageUseCase.execute(requestText: input)
            await handle(entity: entity)
        } catch {
            print("LLM 응답 실패:", error.localizedDescription)
            voiceState = .idle
        }
    }

    /// 목업으로 응답 처리 (테스트용)
    func sendToLLMWithMock() async {
        guard !isProcessing else { return }
        isProcessing = true
        defer { isProcessing = false }

        // 전송 시 녹음 중지 및 초기화
        if isListening {
            stopRecording()
        }

        let input = transcribedText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !input.isEmpty else {
            print("음성 인식 결과가 비어 있습니다.")
            return
        }

        voiceState = .aiSpeaking
        
        // 목업 응답 생성
        let mockResponse = LLMMessageEntity(
            requestText: input,
            responseText: "목업 응답: '\(input)'에 대한 테스트 응답입니다. 이는 실제 AI 응답이 아닌 테스트용 목업 데이터입니다.",
            route: nil
        )
        
        await handle(entity: mockResponse)
    }

    /// 녹음 중지
    func stopRecording() {
        recognizer.stopRecording()
        voiceState = .idle
    }

    /// 합성 중단
    func stopSpeaking() {
        synthesizer.stop()
        voiceState = .idle
    }

    /// 취소 (녹음/합성 종료 + 텍스트 초기화)
    func cancel() {
        recognizer.stopRecording()
        synthesizer.stop()
        transcribedText = ""
        llmResponse = ""
        voiceState = .idle
        isProcessing = false
    }

    /// 전송 완료 후 초기화
    func resetAfterResponse() {
        transcribedText = ""
        voiceState = .idle
    }

    // MARK: - Private Handlers

    /// 성공 처리: 텍스트/합성/라우팅
    private func handle(entity: LLMMessageEntity) async {
        // UI 업데이트
        llmResponse = entity.responseText
        
        // 음성 합성
        synthesizer.speak(text: entity.responseText)

        // 라우팅 필요 시 알림
        if let domain = entity.route,
           let app = RouteAdapter.map(domain) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) { [weak self] in
                self?.onRoute?(app)
            }
        }
        
        // 음성 합성 완료 후 초기화
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
            self?.resetAfterResponse()
        }
    }
}
