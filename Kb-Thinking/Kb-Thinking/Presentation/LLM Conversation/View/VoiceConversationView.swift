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

            // MARK: - 상태 표시 영역
            VStack(spacing: 16) {
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
                
                // 상태 텍스트
                Text(statusText)
                    .font(.headline)
                    .foregroundColor(statusColor)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                // 권한 상태 표시
                if !viewModel.isAuthorized {
                    HStack(spacing: 8) {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundColor(.orange)
                        Text("음성 인식 권한이 필요합니다")
                            .font(.caption)
                            .foregroundColor(.orange)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(Color.orange.opacity(0.1))
                    .cornerRadius(8)
                }
            }

            Spacer()

            // MARK: - 버튼 영역
            HStack(spacing: 24) {

                // 녹음 시작/중지
                VStack(spacing: 6) {
                    Button {
                        viewModel.toggleRecording()
                    } label: {
                        Image(systemName: viewModel.isListening ? "stop.fill" : "mic.fill")
                            .font(.title3)
                            .foregroundColor(viewModel.isListening ? .white : .black)
                            .padding(14)
                            .background(viewModel.isListening ? Color.red : Color(.systemGray6))
                            .clipShape(Circle())
                    }
                    .disabled(viewModel.isProcessing || !viewModel.isAuthorized)
                    .opacity(viewModel.isAuthorized ? 1.0 : 0.5)
                    Text(viewModel.isListening ? "중지" : "녹음").font(.caption).foregroundStyle(.secondary)
                }

                // 취소
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
                    .disabled(viewModel.isProcessing)
                    .accessibilityIdentifier("cancelButton")
                    Text("취소").font(.caption).foregroundStyle(.secondary)
                }

                // 전송
                VStack(spacing: 6) {
                    Button {
                        Task {
                            await viewModel.sendToLLM()   
                        }
                    } label: {
                        Image(systemName: "paperplane.fill")
                            .font(.title3)
                            .foregroundColor(.white)
                            .padding(14)
                            .background(canSend ? Color.blue : Color(.systemGray4))
                            .clipShape(Circle())
                    }
                    .disabled(!canSend || viewModel.isProcessing)
                    .accessibilityIdentifier("sendButton")
                    Text("전송").font(.caption).foregroundStyle(.secondary)
                }
            }
            .padding(.bottom, 16)

            // MARK: - 텍스트 표시 영역
            VStack(spacing: 12) {
                // 사용자 음성 인식 결과
                if !viewModel.transcribedText.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("음성 인식 결과:")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text(viewModel.transcribedText)
                            .font(.body)
                            .foregroundColor(.primary)
                            .padding(12)
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                    }
                    .padding(.horizontal)
                }
                
                // AI 응답
                if !viewModel.llmResponse.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("AI 응답:")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text(viewModel.llmResponse)
                            .font(.body)
                            .foregroundColor(.primary)
                            .padding(12)
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(8)
                    }
                    .padding(.horizontal)
                }
                
                // 안내 메시지
                if viewModel.transcribedText.isEmpty && viewModel.llmResponse.isEmpty {
                    Text("말씀해 보세요…")
                        .font(.callout)
                        .foregroundColor(.gray)
                        .padding(.horizontal)
                }
            }
            .padding(.bottom, 40)
        }
        .ignoresSafeArea(edges: .bottom)
        .background(Color.white)
    }
    
    // MARK: - Computed Properties
    
    private var canSend: Bool {
        !viewModel.transcribedText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    private var statusText: String {
        switch viewModel.voiceState {
        case .idle:
            return viewModel.isListening ? "듣고 있습니다..." : "준비됨"
        case .userSpeaking:
            return "말씀해 주세요..."
        case .aiSpeaking:
            return "AI가 응답하고 있습니다..."
        }
    }
    
    private var statusColor: Color {
        switch viewModel.voiceState {
        case .idle:
            return viewModel.isListening ? .blue : .gray
        case .userSpeaking:
            return .green
        case .aiSpeaking:
            return .orange
        }
    }
}


struct VoiceConversationView_Previews: PreviewProvider {
    
    // MARK: - 1. 간단한 목업 UseCase (실제 Repository 의존성 없음)
    
    static var mockUseCase = SendLLMMessageUseCase(repository: MockLLMConversationRepositoryImpl())


    // MARK: - 2. ViewModel
    
    static var mockViewModel: VoiceConversationViewModel = {
        let vm = VoiceConversationViewModel(sendLLMMessageUseCase: mockUseCase)
        vm.transcribedText = "안녕하세요, KB국민은행에 대해 궁금한 점이 있습니다"
        vm.voiceState = .idle
        vm.isAuthorized = true
        return vm
    }()
    
    static var mockViewModelWithResponse: VoiceConversationViewModel = {
        let vm = VoiceConversationViewModel(sendLLMMessageUseCase: mockUseCase)
        vm.transcribedText = "출금 한도는 얼마인가요?"
        vm.llmResponse = "현재 출금 한도는 100만원까지 설정되어 있어요. 한도를 넘기려면 신분증 인증과 추가 서류 제출이 필요할 수 있어요."
        vm.voiceState = .idle
        return vm
    }()
    
    static var mockViewModelRecording: VoiceConversationViewModel = {
        let vm = VoiceConversationViewModel(sendLLMMessageUseCase: mockUseCase)
        vm.transcribedText = "안녕하세요, KB국민은행에 대해"
        vm.voiceState = .userSpeaking
        vm.isListening = true
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
