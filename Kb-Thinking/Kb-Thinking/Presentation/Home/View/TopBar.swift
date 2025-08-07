//
//  TopBar.swift
//  Kb-Thinking
//
//  Created by jeonguk29 on 8/7/25.
//

import SwiftUI

struct TopBar: View {
    var body: some View {
        HStack(alignment: .center) {
            
            Button {
                // Action
                
            } label: {
                HStack {
                    Image(systemName: "person.2.fill")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 14, height: 14)
                    
                    Text("패밀리")
                        .font(.system(size: 14, weight: .medium))
                    
                }
            }
            .foregroundColor(Color(UIColor.darkGray))
            .padding(.vertical, 6)
            .padding(.horizontal, 14)
            .overlay(
                Capsule()
                    .stroke(Color(UIColor.systemGray4), lineWidth: 1)
            )
            
            Text("정정욱님")
                .font(.headline)
            Image(systemName: "chevron.right")
            
            Spacer()
            HStack(spacing: 20) {
                Image(systemName: "bell")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                Image(systemName: "magnifyingglass")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                Image(systemName: "line.3.horizontal")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
            }
            .padding(.horizontal)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        TopBar()
            .previewLayout(.device)

        TopBar()
            .previewLayout(.sizeThatFits)
    }
}
