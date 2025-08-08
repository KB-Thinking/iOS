//
//  LLMMessageUseCase.swift
//  Kb-Thinking
//
//  Created by jeonguk29 on 8/8/25.
//

import Foundation

struct SendLLMMessageUseCase {
    private let repository: LLMConversationRepository

    init(repository: LLMConversationRepository) {
        self.repository = repository
    }

    func execute(requestText: String) async throws -> LLMMessageEntity {
        return try await repository.sendMessage(requestText: requestText)
    }
}
