//
//  AccountRepositoryImpl.swift
//  Kb-Thinking
//
//  Created by jeonguk29 on 8/7/25.
//

import Foundation

// 실제 구현체
//final class AccountRepositoryImpl: AccountRepository {
//    func fetchAccounts() async throws -> [AccountEntity] {
//        let dtoList = try await apiService.get("/accounts")
//        return dtoList.map { $0.toEntity() }
//    }
//}

#if DEBUG
final class MockAccountRepositoryImpl: AccountRepository {
    func fetchAccounts() async throws -> [AccountEntity] {
        AccountEntity.mockList
    }
}
#endif
