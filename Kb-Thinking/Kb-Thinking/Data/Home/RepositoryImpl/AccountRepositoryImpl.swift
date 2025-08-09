//
//  AccountRepositoryImpl.swift
//  Kb-Thinking
//
//  Created by jeonguk29 on 8/7/25.
//

import Foundation

final class AccountRepositoryImpl: AccountRepository {
    private let apiService: AccountAPIServiceProtocol

    init(apiService: AccountAPIServiceProtocol = AccountAPIService()) {
        self.apiService = apiService
    }

    func fetchAccounts() async throws -> [AccountEntity] {
        let dtoList = try await apiService.fetchAccounts()
        return dtoList.map { $0.toEntity() }
    }
}

#if DEBUG
final class MockAccountRepositoryImpl: AccountRepository {
    func fetchAccounts() async throws -> [AccountEntity] {
        AccountEntity.mockList
    }
}
#endif
