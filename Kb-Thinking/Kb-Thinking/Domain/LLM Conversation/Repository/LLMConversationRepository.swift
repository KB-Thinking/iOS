//
//  LLMConversationRepository.swift
//  Kb-Thinking
//
//  Created by jeonguk29 on 8/8/25.
//

import Foundation

protocol LLMConversationRepository {
    func sendMessage(requestText: String) async throws -> LLMMessageEntity
}
