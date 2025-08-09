//
//  KBTopNavBar.swift
//  Kb-Thinking
//
//  Created by jeonguk29 on 8/9/25.
//

import SwiftUI

struct KBTopNavBar: View {
    var title: String
    var onBack: (() -> Void)?
    var body: some View {
        HStack(spacing: 12) {
            Button(action: { onBack?() }) {
                Image(systemName: "chevron.left")
                    .font(.title3.weight(.semibold))
                    .foregroundStyle(Color.black)
            }
            Text(title)
                .font(.system(size: 18, weight: .semibold))
            Spacer()
            HStack(spacing: 16) {
                Image(systemName: "ellipsis.bubble")  // 상담
                Image(systemName: "house")             // 홈
                Image(systemName: "line.3.horizontal") // 메뉴
            }
            .font(.headline)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(Color(.systemBackground))
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    KBTopNavBar(title: "이체한도 조회/변경")
}
