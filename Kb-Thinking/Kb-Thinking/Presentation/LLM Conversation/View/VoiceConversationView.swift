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
        case .idle: return 2.0
        case .userSpeaking: return 0.9
        case .aiSpeaking: return 1.2
        }
    }
    
    var body: some View {
        VStack {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(
                        RadialGradient(
                            gradient: Gradient(colors: [
                                Color.white.opacity(0.9),      // 중심 노란빛
                                Color(red: 1.0, green: 0.9, blue: 0.5), // 연노랑
                                Color(red: 1.0, green: 0.8, blue: 0.2)  // 바깥쪽 짙은 노랑
                            ]),
                            center: .center,
                            startRadius: 10,
                            endRadius: 120
                        )
                    )
                    .frame(width: animate ? 220 : 180, height: animate ? 220 : 180)
                    .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 4) // 부드러운 그림자
                    .animation(
                        .easeInOut(duration: animationDuration)
                        .repeatForever(autoreverses: true),
                        value: animate
                    )
                    .onAppear {
                        animate = true
                    }
            }
            
            Spacer()
            
            // MARK: - 각 버튼들
            HStack(spacing: 32) {
                Button {
                    viewModel.voiceState = .userSpeaking
                    viewModel.startListening()
                } label: {
                    Image(systemName: "mic.fill")
                        .foregroundColor(.black)
                        .padding()
                        .background(Color(.systemGray6))
                        .clipShape(Circle())
                }
                
                Button {
                    Task {
                        viewModel.voiceState = .aiSpeaking
                        await viewModel.stopListeningAndRespondWithMock()
                    }
                } label: {
                    Image(systemName: "waveform")
                        .foregroundColor(.black)
                        .padding()
                        .background(Color(.systemGray6))
                        .clipShape(Circle())
                }
                
                Button {
                    viewModel.voiceState = .idle
                    viewModel.stopSpeaking()
                } label: {
                    Image(systemName: "xmark")
                        .foregroundColor(.black)
                        .padding()
                        .background(Color(.systemGray6))
                        .clipShape(Circle())
                }
            }
            .padding(.bottom, 16)
            
            // 텍스트 출력
            Text(viewModel.transcribedText)
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
