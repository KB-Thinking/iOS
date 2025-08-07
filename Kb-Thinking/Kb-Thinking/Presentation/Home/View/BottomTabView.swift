//
//  BottomTabView.swift
//  Kb-Thinking
//
//  Created by jeonguk29 on 8/6/25.
//

import SwiftUI

struct BottomTabView: View {
    var body: some View {
        HStack {
            Spacer()
            TabItem(icon: "wonsign.circle", title: "상품")
            Spacer()
            TabItem(icon: "chart.pie", title: "자산")
            Spacer()
            TabItem(icon: "wallet.pass", title: "지갑", highlighted: true)
            Spacer()
            TabItem(icon: "gift", title: "혜택")
            Spacer()
            TabItem(icon: "square.grid.2x2", title: "테마")
            Spacer()
        }
        .padding()
        .background(.white)
    }
}

struct TabItem: View {
    let icon: String
    let title: String
    var highlighted: Bool = false
    
    var body: some View {
        VStack {
            Image(systemName: icon)
                .foregroundColor(highlighted ? .yellow : .gray)
            Text(title)
                .font(.caption)
                .foregroundColor(highlighted ? .yellow : .gray)
        }
    }
}

#Preview {
    BottomTabView()
}
