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
    @Published var voiceState: VoiceState = .idle
    
    // MARK: - Dependencies
    
    private let recognizer = SpeechRecognizerManager()
    private let synthesizer = SpeechSynthesizerManager()
    private let sendLLMMessageUseCase: SendLLMMessageUseCase
    
    private var cancellables = Set<AnyCancellable>()
    
    init(sendLLMMessageUseCase: SendLLMMessageUseCase) {
        self.sendLLMMessageUseCase = sendLLMMessageUseCase
        
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
            transcribedText = "음성 인식 시작 실패: \(error.localizedDescription)"
            voiceState = .idle
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
        
        let userText = transcribedText
        voiceState = .aiSpeaking
        
        // 목업 응답 사용
        let mock = LLMMessageEntity.mockList.randomElement()
        let reply = mock?.responseText ?? "죄송해요, 응답을 가져오지 못했어요."
        
        transcribedText = reply
        synthesizer.speak(text: reply)
        
        voiceState = .idle
    }
}
