//
//  AccountDTO.swift
//  Kb-Thinking
//
//  Created by jeonguk29 on 8/7/25.
//

import SwiftUI

// Swift의 Decodable은 재귀적으로 작동하위 타입이 Decodable을 따르지 않으면 전체 디코딩이 실패
struct AccountDTO: Decodable {
    let id: String
    let name: String
    let number: String
    let balance: Int
    let holders: [AccountHolderDTO]

    func toEntity() -> AccountEntity {
        .init(id: id, name: name, number: number, balance: balance, holders: holders.map { $0.toEntity() })
    }
}

struct AccountHolderDTO: Identifiable, Decodable {
    let id = UUID()
    let name: String
    let image: String

    private enum CodingKeys: String, CodingKey {
         case name = "user_name" // 보통 DTO가 이런식으로 날아올것
         case image = "user_image"
     }
    
    func toEntity() -> AccountHolderEntity {
        .init(name: name, image: image)
    }
}
