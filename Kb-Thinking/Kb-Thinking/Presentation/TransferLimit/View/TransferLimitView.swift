//
//  TransferLimitView.swift
//  Kb-Thinking
//
//  Created by jeonguk29 on 8/9/25.
//

import SwiftUI

struct TransferLimitView: View {
    let dayLimit = "1,000,000원"
    let onceLimit = "1,000,000원"
    let todaySum = "0원"
    let todayRemain = "1,000,000원"
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                KBTopNavBar(title: "이체한도 조회/변경")
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        // 섹션 타이틀
                        Text("나의 이체한도")
                            .font(.system(size: 18, weight: .semibold))
                            .padding(.top, 18)
                        
                        Divider()
                        
                        // 한도 표
                        VStack(spacing: 0) {
                            LimitRow(title: "1일 이체한도", value: dayLimit)
                            LimitRow(title: "1회 이체한도", value: onceLimit)
                            LimitRow(title: "당일 이체금액합계", value: todaySum)
                            LimitRow(title: "당일 이체잔여한도", value: todayRemain)
                            
                            HStack(alignment: .top) {
                                Text("변경가능 이체한도 (1회/1일)")
                                    .foregroundStyle(.secondary)
                                Spacer()
                                Button {
                                    // 링크 액션 자리
                                } label: {
                                    Text("최대 1천만원/최대 1천만원")
                                        .font(.subheadline.weight(.semibold))
                                }
                            }
                            .padding(.top, 12)
                        }
                        
                        Divider()
       
                        InfoCard()
                            .padding(.horizontal, 10)
                        
                        Spacer(minLength: 100) // 하단 버튼 여백
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 24)
                }
            }
            
            // 고정 하단 버튼
            VStack {
                Spacer()
                Button(action: {
                    // 이체한도 변경 액션 자리
                }) {
                    Text("이체한도 변경")
                        .font(.system(size: 17, weight: .semibold))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                }
                .buttonStyle(.plain)
                .background(Color.yellow)
                .clipShape(RoundedRectangle(cornerRadius: 2))
                .padding(.horizontal, 16)
                .padding(.bottom, 30)
                .shadow(radius: 1, y: 1)
            }
        }
        .ignoresSafeArea(edges: .bottom) 
    }
}

// MARK: - Rows (나의 이체한도)
struct LimitRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack(alignment: .top) {
            Text(title)
                .foregroundStyle(.secondary)
            Spacer()
            Text(value)
                .fontWeight(.semibold)
        }
        .padding(.vertical, 12)
       
    }
}

// MARK: - 회색 카드(필수 준비사항 / 안내사항)
struct InfoCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("필수 준비사항")
                .font(.system(size: 16, weight: .semibold))
            
            VStack(alignment: .leading, spacing: 8) {
                HStack(alignment: .top, spacing: 8) {
                    Text("•")
                    Text("이체한도 증액 시: 신분증(주민등록증, 운전면허증, 여권) 및 인증서\n– 공동인증서, 금융인증서는 OTP/보안카드 필요")
                }
            }
            .font(.subheadline)
            .foregroundStyle(.secondary)
         
            
            Text("안내사항")
                .font(.system(size: 16, weight: .semibold))
                .padding(.top)
            
            VStack(alignment: .leading, spacing: 8) {
                HStack(alignment: .top, spacing: 8) {
                    Image(systemName: "info.circle")
                    Text("금융거래한도제한 계좌는 인터넷뱅킹 이체한도와 한도제한 금액 중 “작은 금액” 이내로 이체 가능합니다.")
                        .foregroundStyle(Color.blue)
                }
                .font(.subheadline)
                
                VStack(alignment: .leading, spacing: 6) {
                    Text("＊ 1일 한도제한 금액")
                    Text("– 2016.3.17까지 개설된 계좌: 700만원")
                    Text("– 2016.3.20 이후 개설된 계좌: 100만원(단, 한도유지 신청계좌: 300만원)")
                }
                .font(.footnote)
                .foregroundStyle(.secondary)
                
                VStack(alignment: .leading, spacing: 6) {
                    Text("＊ 금융거래한도제한 해제 방법")
                    Text("– [전체계좌조회] > 더보기 > 한도제한해제 신청 메뉴에서 해제 가능")
                    Text("– 단, 비대면 한도제한 해제 기준 충족 필요(전산사후검증)")
                }
                .font(.footnote)
                .foregroundStyle(.secondary)
            }
        }
        .padding(16)
        .background(.gray.opacity(0.08))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

#Preview {
    TransferLimitView()
}
