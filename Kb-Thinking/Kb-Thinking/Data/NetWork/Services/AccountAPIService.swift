//
//  AccountAPIService.swift
//  Kb-Thinking
//
//  Created by jeonguk29 on 8/8/25.
//

import Foundation

protocol AccountAPIServiceProtocol {
    func fetchAccounts() async throws -> [AccountDTO]
}

final class AccountAPIService: AccountAPIServiceProtocol {
    func fetchAccounts() async throws -> [AccountDTO] {
//        return try await APIService.shared.request(
//            path: Endpoint.Account.fetchAccounts.path,
//            method: Endpoint.Account.fetchAccounts.method,
//            responseType: [AccountDTO].self
//        )
        return [AccountDTO]()
    }
}
