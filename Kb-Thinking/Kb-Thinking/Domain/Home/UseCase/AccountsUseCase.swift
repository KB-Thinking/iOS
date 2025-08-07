//
//  AccountsUseCase.swift
//  Kb-Thinking
//
//  Created by jeonguk29 on 8/7/25.
//

import Foundation

class AccountsUseCase {
    private let repository: AccountRepository

    init(repository: AccountRepository) {
        self.repository = repository
    }

    func execute() async throws -> [AccountEntity] {
        return try await repository.fetchAccounts()
    }
}
