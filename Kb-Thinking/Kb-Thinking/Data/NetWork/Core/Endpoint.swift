//
//  Endpoint.swift
//  Kb-Thinking
//
//  Created by jeonguk29 on 8/8/25.
//

import Foundation

enum Endpoint {
    
    // MARK: - Main
    
    enum Main {
        case getMain
        
        var path: String {
            switch self {
            case .getMain:
                return "/api/v1/main"
            }
        }
        
        var method: HTTPMethod {
            switch self {
            case .getMain:
                return .GET
            }
        }
    }
    
    // MARK: - Club
    
    enum Club {
        case getMyClubs
        case getClubDetail(clubId: String)
        case postClubChat(clubId: String)
        
        var path: String {
            switch self {
            case .getMyClubs:
                return "/api/v1/club"
                
            case .getClubDetail(let clubId):
                return "/api/v1/club/\(clubId)"
                
            case .postClubChat(let clubId):
                return "/api/v1/club/\(clubId)/chat"
                
            }
        }
        
        var method: HTTPMethod {
            switch self {
            case .getMyClubs,
                    .getClubDetail:
                return .GET
            case .postClubChat:
                return .POST
            }
        }
    }
}
