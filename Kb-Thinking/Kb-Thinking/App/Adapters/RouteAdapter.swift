//
//  RouteAdapter.swift
//  Kb-Thinking
//
//  Created by jeonguk29 on 8/11/25.
//

import Foundation

// MARK: - 서버(Route)와 앱(AppRoute)의 중간 번역기.
/// 서버 계약이 바뀌거나, 같은 서버 라우트가 플랫폼별 다른 화면으로 연결되어야 할 때 여기만 수정.

struct RouteAdapter {
    static func map(_ domain: Route) -> AppRoute? {
        switch domain {
        case .limit: return .limit
        }
    }
}
