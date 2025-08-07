//
//  WalletHomeView.swift
//  Kb-Thinking
//
//  Created by jeonguk29 on 8/6/25.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        ZStack(alignment: .top) {
            // 1. 전체 배경: 위에서 아래로 흰색 → 라이트 그레이
            LinearGradient(
                gradient: Gradient(colors: [Color.white, Color(UIColor.systemGray6)]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack {
                ScrollView {
                    VStack(spacing: 16) {
                        TopBar()
                            .padding(.top, 20)
                            .padding(.horizontal)
                        
                        PromotionBannerView()
                        
                        AccountCardView()

                        // 4. 페이지 인디케이터 및 자산 연결 알림
                        HStack {
                            Image(systemName: "chevron.left")
                            Text("1 / 4")
                                .font(.subheadline)
                            Image(systemName: "chevron.right")
                            Spacer()
                            
                            Button {
                                // Action
                                
                            } label: {
                                Text("전체계좌 보기")
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
                        .padding(.horizontal)
                        
                        LinkAlertView
                            .padding(.horizontal)
                        
                        SpendingCardView
                            .padding(.horizontal)
                        
                        Spacer()
                    }
                }
                BottomTabView()
            }
        }
    }
}


// MARK: - PromotionBannerView
private struct PromotionBannerView: View {
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("대한민국 공식 모바일 신분증")
                        .font(.headline)
                        .foregroundColor(.black)
                    Text("지금 바로 등록해보세요!")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }

                Spacer()

                Image("PromotionBanner")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 60, height: 60)
            }
            .padding(.horizontal)

            HStack(spacing: 4) {
                Spacer()
                RoundedRectangle(cornerRadius: 3)
                    .frame(width: 20, height: 4)
                    .foregroundColor(.gray)

                ForEach(0..<4) { _ in
                    Circle()
                        .frame(width: 4, height: 4)
                        .foregroundColor(.gray.opacity(0.5))
                }

                Image(systemName: "chevron.right")
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
                Spacer()
            }
        }
        .padding(10)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.gray.opacity(0.1))
        )
        .padding(.horizontal)
    }
}

// MARK: - LinkAlertView : 자산 연결 메시지
private var LinkAlertView: some View {
    HStack {
        Image(systemName: "link")
            .resizable()
            .scaledToFit()
            .frame(width: 14, height: 14)
            .foregroundColor(.white)
            .padding(8)
            .background(Circle().fill(Color.orange))
        Text("연결을 기다리는 자산이 있어요")
            .font(.subheadline)
        
        Image(systemName: "chevron.right")
            .font(.system(size: 13, weight: .medium))
            .foregroundColor(.gray)
        Spacer()
    }
    .padding(.horizontal)
    .frame(height: 70)
    .background(Color.white)
    .cornerRadius(16)
    .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
}

// MARK: - SpendingCardView : 정기지출 섹션
private var SpendingCardView: some View {
    VStack(spacing: 0) {
        // 첫 번째 항목: 정기지출
        VStack {
            HStack {
                Text("이번 달 정기지출")
                    .font(.body)
                    .foregroundColor(.primary)
                Spacer()
            }
            HStack {
                Spacer()
                VStack(alignment: .trailing, spacing: 4) {
                    HStack(spacing: 4) {
                        Text("54,988원")
                            .bold()
                            .foregroundColor(.primary)
                        Image(systemName: "chevron.right")
                            .font(.system(size: 13, weight: .medium))
                            .foregroundColor(.gray)
                    }
                    Text("2025.08.06 21:10 기준")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
        }
        .padding()
        
        Divider()
            .padding(.leading)
        
        // 두 번째 항목: 오늘 지출 여부
        VStack {
            HStack {
                Text("오늘은 지출 계획이 없으신가요?")
                    .font(.body)
                Image(systemName: "chevron.right")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(.gray)
                Spacer()
                
            }
            .padding()
            .padding(.top, 12)
            
            HStack {
                Spacer()
                Text("2025.08.06 21:10 기준")
                    .font(.caption)
                    .foregroundColor(.gray)
                    .padding([.horizontal, .bottom])
            }
        }
        
    }
    .background(Color.white)
    .cornerRadius(16)
    .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
}

#Preview {
    HomeView()
}
