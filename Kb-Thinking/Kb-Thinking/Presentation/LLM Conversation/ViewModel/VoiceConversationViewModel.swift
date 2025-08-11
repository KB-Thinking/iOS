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
    
    // MARK: - Published Properties
    
    @Published var transcribedText: String = ""
    @Published var llmResponse = ""
    @Published var voiceState: VoiceState = .idle
    var onRoute: ((AppRoute?) -> Void)?
    
    // MARK: - Dependencies
    
    private let recognizer = SpeechRecognizerManager()
    private let synthesizer = SpeechSynthesizerManager()
    private let sendLLMMessageUseCase: SendLLMMessageUseCase
    
    private var cancellables = Set<AnyCancellable>()
    
    init(sendLLMMessageUseCase: SendLLMMessageUseCase) {
        self.sendLLMMessageUseCase = sendLLMMessageUseCase
        
        recognizer.requestAuthorization { status in
            print("권한 상태: \(status)")
        }

        // Combine 바인딩
        recognizer.$recognizedText
            .receive(on: DispatchQueue.main)
            .assign(to: &$transcribedText)
    }
    
    // MARK: - Methods
    
    func startListening() {
        voiceState = .userSpeaking
        transcribedText = ""

        do {
            try recognizer.startRecording()
        } catch {
            print("🎤 음성 인식 시작 실패:", error.localizedDescription)
        }
    }
    
    func stopListeningAndAskLLM() async {
        recognizer.stopRecording()
        let input = transcribedText
        
        do {
            voiceState = .aiSpeaking
            let entity = try await sendLLMMessageUseCase.execute(requestText: input)
            transcribedText = entity.responseText
            synthesizer.speak(text: entity.responseText)
        } catch {
            transcribedText = "❌ 응답 실패: \(error.localizedDescription)"
        }
        
        voiceState = .idle
    }
    
    func stopSpeaking() {
        synthesizer.stop()
        voiceState = .idle
    }
    
    // MARK: - 목업 응답
    func stopListeningAndRespondWithMock() async {
        recognizer.stopRecording()
        voiceState = .aiSpeaking
        
        // 4번째 목업 고정
        let mock = LLMMessageEntity.mockList[3]
        
        transcribedText = mock.responseText
        synthesizer.speak(text: mock.responseText)
        
        // route가 있으면 화면 이동 콜백 실행
        if let domainRoute = mock.route,
           let appRoute = RouteAdapter.map(domainRoute) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                self.onRoute?(appRoute)
            }
        }
        
        voiceState = .idle
    }
}

// MARK: - 라우터 관련
extension VoiceConversationViewModel {
    func send(_ text: String) {
        Task {
            do {
                let entity = try await sendLLMMessageUseCase.execute(requestText: text)
                await MainActor.run {
                    self.llmResponse = entity.responseText
                    if let domainRoute = entity.route,
                       let appRoute = RouteAdapter.map(domainRoute) {
                        self.onRoute?(appRoute)
                    }
                }
            } catch {
                // 에러 처리 (토스트/알럿 등)
            }
        }
    }
}
