//
//  AccountRepository.swift
//  Kb-Thinking
//
//  Created by jeonguk29 on 8/7/25.
//

import Foundation

// Repository Protocol
protocol AccountRepository {
    func fetchAccounts() async throws -> [AccountEntity]
}
