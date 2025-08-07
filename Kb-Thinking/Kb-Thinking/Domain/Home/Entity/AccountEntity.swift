//
//  AccountEntity.swift
//  Kb-Thinking
//
//  Created by jeonguk29 on 8/7/25.
//

import Foundation

struct AccountEntity {
    let id: String
    let name: String
    let number: String
    let balance: Int
    let holders: [AccountHolderEntity]
}

struct AccountHolderEntity: Identifiable {
    let id = UUID()
    let name: String
    let image: String
}
