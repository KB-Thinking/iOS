//
//  HomeMocks.swift
//  Kb-Thinking
//
//  Created by jeonguk29 on 8/7/25.
//

import Foundation

extension AccountEntity {
    static var mockList: [AccountEntity] {
        [
            AccountEntity(
                id: "1",
                name: "정정욱저축",
                number: "937702-00-876440",
                balance: 309_877,
                holders: [
                    AccountHolderEntity(name: "정정욱", image: "KBLogo"),
                    AccountHolderEntity(name: "윤재남", image: "KBLogo"),
                    AccountHolderEntity(name: "양봉섭", image: "KBLogo"),
                    AccountHolderEntity(name: "유재수", image: "KBLogo")
                ]
            ),
            AccountEntity(
                id: "2",
                name: "생활비통장",
                number: "123456-78-9101112",
                balance: 1_250_000,
                holders: [
                    AccountHolderEntity(name: "김생활", image: "KBLogo")
                ]
            ),
            AccountEntity(
                id: "3",
                name: "비상금통장",
                number: "345678-90-1234567",
                balance: 3_000_000,
                holders: [
                    AccountHolderEntity(name: "이비상", image: "KBLogo")
                ]
            ),
            AccountEntity(
                id: "4",
                name: "여행자금통장",
                number: "765432-10-1110987",
                balance: 820_000,
                holders: [
                    AccountHolderEntity(name: "박여행", image: "KBLogo")
                ]
            )
        ]
    }
}
