//
//  LLMConversationRepositoryImpl.swift
//  Kb-Thinking
//
//  Created by jeonguk29 on 8/8/25.
//

import Foundation

final class LLMConversationRepositoryImpl: LLMConversationRepository {
    private let apiService: LLMConversationAPIServiceProtocol

    init(apiService: LLMConversationAPIServiceProtocol = LLMConversationAPIService()) {
        self.apiService = apiService
    }

    func sendMessage(requestText: String) async throws -> LLMMessageEntity {
        let responseDTO = try await apiService.sendMessage(requestText: requestText)
        return responseDTO.toEntity(requestText: requestText)
    }
}

#if DEBUG
final class MockLLMConversationRepositoryImpl: LLMConversationRepository {
    func sendMessage(requestText: String) async throws -> LLMMessageEntity {
        LLMMessageEntity.mockList.randomElement() ?? LLMMessageEntity.mockList.first!
    }
}
#endif
