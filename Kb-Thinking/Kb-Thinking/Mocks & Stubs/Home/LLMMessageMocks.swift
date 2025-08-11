//
//  LLMMessageMocks.swift
//  Kb-Thinking
//
//  Created by jeonguk29 on 8/8/25.
//

import Foundation

extension LLMMessageEntity {
    static var mockList: [LLMMessageEntity] {
        [
            LLMMessageEntity(
                requestText: "300만원을 출금해줘.",
                responseText: "현재 출금 한도는 100만원까지 설정되어 있습니다. 한도를 올리려면 신분증 인증과 추가 서류 제출이 필요합니다. 예를 들어, 건강보험 고지서나 세금 고지서를 제출하시면 한도 상향이 가능합니다.",
                route: nil
            ),
            LLMMessageEntity(
                requestText: "건강보험 고지서도 필요해? 어떻게 제출하면 돼?",
                responseText: "네, 건강보험 고지서는 KB 모바일뱅킹 앱의 '서류 제출' 메뉴에서 촬영·업로드하시면 됩니다. 해당 절차를 진행하시면 한도를 올릴 수 있습니다.",
                route: nil
            ),
            LLMMessageEntity(
                requestText: "증권으로 돈 옮기려고 하는데도 필요한 거야?",
                responseText: "맞습니다. 증권 계좌로 송금할 때도 한도 초과 시 서류 제출 후 한도 상향 절차가 필요합니다. 지금 서류 제출 화면으로 안내해 드릴까요?",
                route: nil
            ),
            LLMMessageEntity(
                requestText: "그래, 이동시켜줘. 그럼 증권 송금도 똑같은 거지?",
                responseText: "네, 서류 제출 후 한도 상향이 완료되면 증권 송금도 바로 가능합니다. 지금 서류 제출 화면으로 이동하겠습니다. 서류를 준비해 주세요!",
                route: .limit 
            )
        ]
    }
}
