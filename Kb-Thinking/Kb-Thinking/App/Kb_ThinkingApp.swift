//
//  Kb_ThinkingApp.swift
//  Kb-Thinking
//
//  Created by jeonguk29 on 8/6/25.
//

import SwiftUI

@main
struct Kb_ThinkingApp: App {
    var body: some Scene {
        WindowGroup {
            let apiService = LLMConversationAPIService()
            let repository = LLMConversationRepositoryImpl(apiService: apiService)
            let useCase = SendLLMMessageUseCase(repository: repository)
            let viewModel = VoiceConversationViewModel(sendLLMMessageUseCase: useCase)

            VoiceConversationView(viewModel: viewModel)
        }
    }
}
