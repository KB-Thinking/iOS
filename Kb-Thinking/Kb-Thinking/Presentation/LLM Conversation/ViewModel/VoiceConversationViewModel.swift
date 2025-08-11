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

    /// 화면(Presentation)으로 라우팅 신호 전달
    var onRoute: ((AppRoute?) -> Void)?

    // MARK: - Dependencies
    private let recognizer = SpeechRecognizerManager()
    private let synthesizer = SpeechSynthesizerManager()
    private let sendLLMMessageUseCase: SendLLMMessageUseCase

    // MARK: - Lifecycle
    init(sendLLMMessageUseCase: SendLLMMessageUseCase) {
        self.sendLLMMessageUseCase = sendLLMMessageUseCase

        recognizer.requestAuthorization { status in
            print("권한 상태:", status)
        }

        // 음성 인식 텍스트를 UI 바인딩
        recognizer.$recognizedText
            .receive(on: DispatchQueue.main)
            .assign(to: &$transcribedText)
    }

    // MARK: - Public API (View에서 호출)

    /// 녹음 시작
    func startListening() {
        voiceState = .userSpeaking
        transcribedText = ""
        do {
            try recognizer.startRecording()
        } catch {
            print("🎤 음성 인식 시작 실패:", error.localizedDescription)
        }
    }

    /// (실통신) 녹음 종료 후 LLM에 전송
    func stopListeningAndAskLLM() async {
        recognizer.stopRecording()
        let input = transcribedText

        voiceState = .aiSpeaking
        do {
            let entity = try await sendLLMMessageUseCase.execute(requestText: input)
            await handle(entity: entity)
        } catch {
            await handle(error: error)
        }
    }

    /// (목업) 녹음 종료 후 목업 응답 처리
    func stopListeningAndRespondWithMock(index: Int = 3) async {
        recognizer.stopRecording()
        voiceState = .aiSpeaking

        // 인덱스 안전 가드
        let list = LLMMessageEntity.mockList
        let mock = list[index]
        await handle(entity: mock)
    }

    /// 합성 중단/초기화
    func stopSpeaking() {
        synthesizer.stop()
        voiceState = .idle
    }

    /// 취소(녹음/합성 종료 + 텍스트 초기화)
    func cancel() {
        recognizer.stopRecording()
        synthesizer.stop()
        transcribedText = ""
        llmResponse = ""
        voiceState = .idle
    }

    /// View에서 “전송” 버튼에 매핑할 함수
    /// - 데모: 목업/실통신 전환은 여기서 스위치
    func sendToLLM(useMock: Bool = false) async {
        if useMock {
            await stopListeningAndRespondWithMock()
        } else {
            await stopListeningAndAskLLM()
        }
    }

    // MARK: - Private Common Handlers

    /// 성공 공통 처리: 텍스트/합성/라우팅 한 번에
    private func handle(entity: LLMMessageEntity) async {
        // UI 업데이트
        llmResponse = entity.responseText
        transcribedText = entity.responseText

        // 음성 합성
        synthesizer.speak(text: entity.responseText)

        // 라우팅 필요 시 알림 (Domain Route → AppRoute)
        if let domain = entity.route,
           let app = RouteAdapter.map(domain) {
            // 시트 닫힘 애니와 충돌 방지 약간의 여유(필요 시 제거/조정)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) { [weak self] in
                self?.onRoute?(app)
            }
        }

        voiceState = .idle
    }

    /// 에러 공통 처리: 메시지 표시 + 상태 정리
    private func handle(error: Error) async {
        transcribedText = "❌ 응답 실패: \(error.localizedDescription)"
        voiceState = .idle
    }
}
