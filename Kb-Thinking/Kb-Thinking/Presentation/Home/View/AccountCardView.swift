//
//  AccountCardView.swift
//  Kb-Thinking
//
//  Created by jeonguk29 on 8/6/25.
//

import SwiftUI

struct AccountCardView: View {
    let account: AccountEntity
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            VStack(alignment: .leading) {
                HStack(alignment: .top) {
                    Image("KBLogo")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 20, height: 20)
                        .clipShape(Circle())
                    
                    VStack(alignment: .leading) {
                        VStack(alignment: .leading) {
                            Text(account.name)
                                .font(.headline)
                            Text(account.number)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                                .padding(.bottom, 20)
                            
                            HStack {
                                Text("\(account.balance)")
                                    .font(.title2)
                                    .bold()
                                Button {
                                    // Action
                                    
                                } label: {
                                    Text("숨김")
                                        .font(.system(size: 14, weight: .medium))
                                        .foregroundColor(Color(UIColor.darkGray))
                                        .padding(.vertical, 6)
                                        .padding(.horizontal, 14)
                                        .overlay(
                                            Capsule()
                                                .stroke(Color(UIColor.systemGray4), lineWidth: 1)
                                        )
                                }
                            }
                            
                            HStack {
                                Button("계좌이체") {}
                                    .foregroundColor(Color(UIColor.darkGray))
                                    .padding()
                                    .frame(maxWidth: .infinity, maxHeight: 40)
                                    .background(Color.yellow)
                                    .cornerRadius(2)
                                Button("연락처 이체") {}
                                    .foregroundColor(Color(UIColor.darkGray))
                                    .padding()
                                    .frame(maxWidth: .infinity, maxHeight: 40)
                                    .background(Color.gray.opacity(0.2))
                                    .cornerRadius(2)
                            }
                        }
                        
                     
                    }
                    
                    
                    VerticalEllipsisButton()
                }
            }
            
            UserAvatarScrollView(users: account.holders)
        }
        .padding()
        .background(Color(UIColor.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 2)
        .padding(.horizontal)
    }
}

private struct VerticalEllipsisButton: View {
    var body: some View {
        VStack(spacing: 4) {
            Circle().frame(width: 5, height: 5)
            Circle().frame(width: 5, height: 5)
            Circle().frame(width: 5, height: 5)
        }
        .foregroundColor(Color.gray)
        .contentShape(Rectangle()) // 터치 영역 확대
    }
}

private struct UserAvatarScrollView: View {
    let users: [AccountHolderEntity]

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 28) {
                ForEach(users) { user in
                    HStack(spacing: 6) {
                        Image(user.image)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 20, height: 20)
                            .clipShape(Circle())
                        Text(user.name)
                            .font(.system(size: 15))
                            .foregroundColor(Color.gray)
                    }
                }
            }
            .padding(.top)
        }
    }
}

#Preview {
    AccountCardView(account: AccountEntity.mockList[0])
}
