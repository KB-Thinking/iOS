//
//  FundDetailView.swift
//  Kb-Thinking
//
//  Created by jeonguk29 on 8/9/25.
//

import SwiftUI

struct FundDetailView: View {
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                KBTopNavBar(title: "상품상세")
                Divider()

                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        // 경고 배너
                        HStack(alignment: .top, spacing: 12) {
                            RiskBadge()
                                .fixedSize()
                            Text("본 상품은 일반 예금상품과 달리 원금의 일부 또는 전부손실이 발생할 수 있으며, 투자로 인한 손실은 투자자 본인에게 귀속됩니다.")
                                .font(.footnote)
                        }
                        .padding(14)
                        .background(Color.gray.opacity(0.08))
                        .clipShape(RoundedRectangle(cornerRadius: 10))

                        // 상품 헤더
                        VStack(alignment: .leading, spacing: 10) {
                            Text("은퇴시점까지 자산배분 비중을 조절")
                                .font(.caption).foregroundStyle(.secondary)

                            Text("KB 다이나믹 TDF 2040 증권 자투자신탁(주식혼합–재간접형) C-E")
                                .font(.system(size: 22, weight: .semibold))
                                .lineSpacing(2)

                            // 통계 카드
                            VStack(spacing: 14) {
                                HStack {
                                    StatItem(icon: "chart.bar",
                                             title: "상품유형", value: "주식혼합형")
                                    StatItem(icon: "exclamationmark.circle",
                                             title: "위험등급", value: "다소높은위험")
                                    StatItem(icon: "banknote",
                                             title: "운용규모", value: "1,329 억원")
                                }

                                // 수익률 바
                                VStack(spacing: 8) {
                                    HStack {
                                        Text("수익률(3개월)")
                                            .foregroundStyle(.secondary)
                                        Spacer()
                                        Text("9.35%")
                                            .foregroundStyle(.red).fontWeight(.semibold)
                                    }
                                    .padding(.top, 6)
                                }
                            }
                            .padding(16)
                            .background(Color(.systemGray6))
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                        }

                        // 기준가 조회
                        SectionRow(
                            title: "기준가조회",
                            trailing: AnyView(EmptyView())
                        )

                        // 섹션 리스트
                        Group {
                            SectionRow(title: "펀드개요")
                            SectionRow(title: "보수 및 수수료(클래스 비교)")
                            SectionRow(title: "매입 및 환매")
                            SectionRow(title: "펀드분석")
                        }

                        Spacer(minLength: 120)
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 16)
                    .padding(.bottom, 16)
                }
            }

            // 하단 고정 버튼
            VStack {
                Spacer()
                BottomStickyBar()
            }
        }
        .ignoresSafeArea(edges: .bottom)
    }
}

// MARK: - 작은 컴포넌트들
struct RiskBadge: View {
    var body: some View {
        VStack(alignment: .center) {
            Text("원금")
            Text("비보장")
            Text("상품")
        }
        .font(.caption2.weight(.bold))
        .padding(.horizontal, 8).padding(.vertical, 4)
        .foregroundStyle(.white)
        .background(Color.red.opacity(0.85))
        .clipShape(RoundedRectangle(cornerRadius: 6))
    }
}

struct StatItem: View {
    let icon: String
    let title: String
    let value: String
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon).font(.title2)
            VStack(spacing: 2) {
                Text(title).font(.caption).foregroundStyle(.secondary)
                Text(value).font(.subheadline.weight(.semibold))
            }
        }
        .frame(maxWidth: .infinity)
    }
}

struct SectionRow: View {
    let title: String
    var trailing: AnyView? = nil
    var body: some View {
        HStack {
            Text(title)
            Spacer()
            (trailing ?? AnyView(EmptyView()))
            Image(systemName: "chevron.right").foregroundStyle(.tertiary)
        }
        .contentShape(Rectangle())
        .padding(.vertical, 14)
        .overlay(Divider(), alignment: .bottom)
    }
}

// MARK: - 하단 고정 탭
struct BottomStickyBar: View {
    var onConsult: () -> Void = {}
    var onJoin: () -> Void = {}
    var body: some View {
        HStack(spacing: 0) {
            Button(action: onConsult) {
                Text("상담").font(.headline)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity).padding(.vertical, 14)
                    .background(Color(.darkGray))
            }
            Button(action: onJoin) {
                Text("가입").font(.headline)
                    .frame(maxWidth: .infinity).padding(.vertical, 14)
                    .background(Color.yellow)
            }
        }
        .buttonStyle(.plain)
        .background(Color.yellow)
        .clipShape(RoundedRectangle(cornerRadius: 2))
        .padding(.horizontal, 16)
        .padding(.bottom, 30)
        .shadow(radius: 1, y: 1)
    }
}

// MARK: - Preview

#Preview {
    FundDetailView()
}
