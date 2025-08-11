//
//  LLMConversationAPIService.swift
//  Kb-Thinking
//
//  Created by jeonguk29 on 8/8/25.
//

import Foundation

protocol LLMConversationAPIServiceProtocol {
    func sendMessage(requestText: String) async throws -> LLMConversationResponseDTO
}

final class LLMConversationAPIService: LLMConversationAPIServiceProtocol {
    func sendMessage(requestText: String) async throws -> LLMConversationResponseDTO {
        let requestDTO = LLMConversationRequestDTO(requestText: requestText)
        print("서버 실제 호출 :  \(requestText)")
        return try await APIService.shared.request(
            path: Endpoint.LLMConversation.postVoice(userId: "1").path,
            method: Endpoint.LLMConversation.postVoice(userId: "1").method,
            body: try JSONEncoder().encode(requestDTO),
            responseType: LLMConversationResponseDTO.self
        )
    }
}
