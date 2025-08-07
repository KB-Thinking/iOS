//
//  HomeViewModel.swift
//  Kb-Thinking
//
//  Created by jeonguk29 on 8/7/25.
//

import Foundation

@MainActor
final class HomeViewModel: ObservableObject {
    @Published var accounts: [AccountEntity] = []

    private let accountsUseCase: AccountsUseCase

    init(fetchAccountsUseCase: AccountsUseCase) {
        self.accountsUseCase = fetchAccountsUseCase
    }

    func loadAccounts() async {
        do {
            accounts = try await accountsUseCase.execute()
        } catch {
            print("에러 처리")
        }
    }
}
