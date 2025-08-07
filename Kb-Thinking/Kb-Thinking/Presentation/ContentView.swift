//
//  ContentView.swift
//  Kb-Thinking
//
//  Created by jeonguk29 on 8/6/25.
//

import SwiftUI

struct ContentView: View {
    let speaker = SpeechSynthesizerManager()

    var body: some View {
        VStack(spacing: 20) {
            Text("읽어볼 텍스트입니다.")
            Button("읽어줘") {
                speaker.speak(
                    text: "주식형 펀드의 비율을 줄이고, 대신 'KB 안정형 펀드'에 추가 투자하시면 장기적인 안정성을 더할 수 있습니다. 이 펀드는 리스크를 분산시켜 안정적인 수익을 제공합니다.",
                    voiceIdentifier: "com.apple.ttsbundle.Nari-compact"
                )
            }
        }
        .padding()
    }
}



#Preview {
    ContentView()
}
