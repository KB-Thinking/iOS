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
                responseText: "현재 출금 한도는 100만원까지 설정되어 있어요. 한도를 넘기려면 신분증 인증과 추가 서류 제출이 필요할 수 있어요. 예를 들어, 건강보험 고지서나 세금 고지서를 제출하면 한도 상향이 가능해요."
            ),
            LLMMessageEntity(
                requestText: "건강보험 고지서도 필요해? 뭐 어떻게 제출하면 돼?",
                responseText: "네, 건강보험 고지서를 제출하려면 현재 KB 모바일 뱅킹 앱에서 '서류 제출' 메뉴로 이동해 사진을 찍어 업로드하면 돼요. 해당 절차를 진행하면 한도를 올릴 수 있어요"
            ),
            LLMMessageEntity(
                requestText: "그래? 증권으로 돈 옮기려고 하는건데도 필요한거지?",
                responseText: "맞아요! 증권 계좌로 송금할 때도 한도 초과가 필요하므로 서류 제출 후 한도 상향 절차를 밟아야 해요. 지금 바로 서류 제출 화면으로 안내해 드릴까요?"
            ),
            LLMMessageEntity(
                requestText: "그래 이동시켜줘. 그럼 증권으로 송금도 똑같은거지?",
                responseText: "네, 서류 제출 후 한도 상향이 완료되면 바로 증권으로 송금하실 수 있어요. 지금 서류  제출 화면으로 이동하겠습니다. 서류를 준비해주세요!"
            )
        ]
    }
}
