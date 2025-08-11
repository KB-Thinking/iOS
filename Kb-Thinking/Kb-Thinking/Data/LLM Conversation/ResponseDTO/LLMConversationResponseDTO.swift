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
        let route: String? // "" 올 수 있어 Optional
    }
}

// MARK: - Mapper

extension LLMConversationResponseDTO {
    func toEntity(requestText: String) -> LLMMessageEntity {
        let routeEnum: Route? = data.route
            .flatMap { $0.isEmpty ? nil : $0 }   // "" → nil
            .flatMap(Route.init(rawValue:))      // 매칭 안되면 nil

        return LLMMessageEntity(
            requestText: requestText,
            responseText: data.responseText,
            route: routeEnum
        )
    }
}
