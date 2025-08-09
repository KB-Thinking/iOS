//
//  LLMConversationResponseDTO.swift
//  Kb-Thinking
//
//  Created by jeonguk29 on 8/8/25.
//

import Foundation

struct LLMConversationResponseDTO: Decodable {
    let success: Bool
    let status: Int
    let message: String
    let data: ResponseData

    struct ResponseData: Decodable {
        let responseText: String
    }
}

extension LLMConversationResponseDTO {
    func toEntity(requestText: String) -> LLMMessageEntity {
        return LLMMessageEntity(
            requestText: requestText,
            responseText: data.responseText
        )
    }
}
