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
            
            // MARK: - UseCase & ViewModel 구성
            
            // 계좌 정보 UseCase + ViewModel
            let accountRepository = MockAccountRepositoryImpl()
            let fetchAccountsUseCase = AccountsUseCase(repository: accountRepository)
            let homeViewModel: HomeViewModel = {
                let vm = HomeViewModel(fetchAccountsUseCase: fetchAccountsUseCase)
                vm.accounts = AccountEntity.mockList
                return vm
            }()
            // LLM 대화용 UseCase
            // let llmApiService = LLMConversationAPIService()
            // let llmRepository = LLMConversationRepositoryImpl(apiService: llmApiService)
            // let sendLLMUseCase = SendLLMMessageUseCase(repository: llmRepository)

            // HomeView에 전달하면서 VoiceConversationViewModel도 함께 주입
            // HomeView(viewModel: homeViewModel, sendLLMMessageUseCase: sendLLMUseCase)
            
            HomeView(viewModel: homeViewModel)
        }
    }
}

