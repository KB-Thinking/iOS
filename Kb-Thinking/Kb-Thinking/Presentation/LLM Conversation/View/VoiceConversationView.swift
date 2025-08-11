//
//  ContentView.swift
//  Kb-Thinking
//
//  Created by jeonguk29 on 8/6/25.
//

import SwiftUI

enum VoiceState {
    case idle
    case userSpeaking
    case aiSpeaking
}

struct VoiceConversationView: View {
    @StateObject var viewModel: VoiceConversationViewModel
    @State private var animate = false

    var animationDuration: Double {
        switch viewModel.voiceState {
        case .idle:          return 2.0
        case .userSpeaking:  return 0.9
        case .aiSpeaking:    return 1.2
        }
    }

    var body: some View {
        VStack {
            Spacer()

            // 애니메이션 원
            Circle()
                .fill(
                    RadialGradient(
                        gradient: Gradient(colors: [
                            Color.white.opacity(0.9),
                            Color(red: 1.0, green: 0.9, blue: 0.5),
                            Color(red: 1.0, green: 0.8, blue: 0.2)
                        ]),
                        center: .center,
                        startRadius: 10,
                        endRadius: 120
                    )
                )
                .frame(width: animate ? 220 : 180, height: animate ? 220 : 180)
                .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 4)
                .animation(.easeInOut(duration: animationDuration).repeatForever(autoreverses: true),
                           value: animate)
                .onAppear { animate = true }

            Spacer()

            // MARK: - 버튼 영역: 녹음 / 취소 / 전송
            HStack(spacing: 24) {

                // 녹음 시작
                VStack(spacing: 6) {
                    Button {
                        viewModel.voiceState = .userSpeaking
                        viewModel.startListening()
                    } label: {
                        Image(systemName: "mic.fill")
                            .font(.title3)
                            .foregroundColor(.black)
                            .padding(14)
                            .background(Color(.systemGray6))
                            .clipShape(Circle())
                    }
                    Text("녹음").font(.caption).foregroundStyle(.secondary)
                }

                // 취소: 말했던 내용 삭제 + 정지
                VStack(spacing: 6) {
                    Button {
                        viewModel.cancel()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.title3)
                            .foregroundColor(.black)
                            .padding(14)
                            .background(Color(.systemGray6))
                            .clipShape(Circle())
                    }
                    .accessibilityIdentifier("cancelButton")
                    Text("취소").font(.caption).foregroundStyle(.secondary)
                }

                // 전송: 녹음 종료 후 AI 응답 합성
                VStack(spacing: 6) {
                    Button {
                        Task {
                            viewModel.voiceState = .aiSpeaking
                            await viewModel.sendToLLM()   
                        }
                    } label: {
                        Image(systemName: "paperplane.fill")
                            .font(.title3)
                            .foregroundColor(.black)
                            .padding(14)
                            .background(Color(.systemGray6))
                            .clipShape(Circle())
                    }
                    .disabled(viewModel.transcribedText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                    .opacity(viewModel.transcribedText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? 0.4 : 1)
                    .accessibilityIdentifier("sendButton")
                    Text("전송").font(.caption).foregroundStyle(.secondary)
                }
            }
            .padding(.bottom, 16)

            // 현재 텍스트
            Text(viewModel.transcribedText.isEmpty ? "말씀해 보세요…" : viewModel.transcribedText)
                .font(.callout)
                .foregroundColor(.gray)
                .padding(.horizontal)
                .padding(.bottom, 40)
        }
        .ignoresSafeArea(edges: .bottom)
        .background(Color.white)
    }
}


struct VoiceConversationView_Previews: PreviewProvider {
    
    // MARK: - 1. UseCase
    
    static var mockUseCase: SendLLMMessageUseCase {
        SendLLMMessageUseCase(repository: MockLLMConversationRepositoryImpl())
    }

    // MARK: - 2. ViewModel
    
    static var mockViewModel: VoiceConversationViewModel = {
        let vm = VoiceConversationViewModel(sendLLMMessageUseCase: mockUseCase)
        vm.transcribedText = LLMMessageEntity.mockList[2].requestText
        vm.voiceState = .aiSpeaking
        return vm
    }()
    
    // MARK: - 3. Preview
    
    static var previews: some View {
        Group {
            VoiceConversationView(viewModel: mockViewModel)
                .previewDisplayName("🎙️ 음성 대화 - Mock 응답")
        }
    }
}
