//
//  Endpoint.swift
//  Kb-Thinking
//
//  Created by jeonguk29 on 8/8/25.
//

import Foundation

enum Endpoint {
    
    // MARK: - LLMConversation
    
    enum LLMConversation {
        case postVoice(userId: String)
        
        var path: String {
            switch self {
            case .postVoice(let userId):
                return "/api/chat/\(userId)"
            }
        }
        
        var method: HTTPMethod {
            switch self {
            case .postVoice:
                return .POST
            }
        }
    }
}
