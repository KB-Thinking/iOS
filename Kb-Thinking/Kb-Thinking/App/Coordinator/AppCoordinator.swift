//
//  AppCoordinator.swift
//  Kb-Thinking
//
//  Created by jeonguk29 on 8/11/25.
//

import SwiftUI

// MARK: - Coordinator (네비게이션 단일 진입점)
/*
 View가 직접 push/pop 하지 않고 Coordinator가 한다 = Coordinator 패턴.
 Sheet 닫힘과 push 충돌 방지를 위해 딜레이/시점 제어도 중앙에서 처리.
 앱 어디서든 navigate(to:)만 부르면 이동 → 화면 간 결합도↓.
 */
final class AppCoordinator: ObservableObject {
    @Published var path = NavigationPath()
    @Published var showVoiceSheet = false
    
    func handle(domainRoute: Route?) {
        guard let domainRoute, let appRoute = RouteAdapter.map(domainRoute) else { return }
        showVoiceSheet = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            self.path.append(appRoute)
        }
    }
    
    func navigate(to route: AppRoute) {
        path.append(route)
    }
    
    func pop() {
        if !path.isEmpty { path.removeLast() }
    }
}
