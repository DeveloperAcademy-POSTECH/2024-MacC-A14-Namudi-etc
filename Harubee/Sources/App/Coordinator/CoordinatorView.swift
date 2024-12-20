//
//  CoordinatorView.swift
//  Harubee
//
//  Created by 이정동 on 12/20/24.
//

import SwiftUI

struct CoordinatorView: View {
  @State private var onboardingCoordinator = OnboardingCoordinator()
  @State private var mainCoordinator = MainCoordinator()
  @State private var rootSwitcher = RootViewSwitcher()
  
  var body: some View {
    Group {
      switch rootSwitcher.root {
      case .onboarding:
        onboardingView
      case .main:
        mainView
      }
    }
    .environment(rootSwitcher)
    .onChange(of: rootSwitcher.root) { oldValue, _ in
      switch oldValue {
      case .onboarding:
        onboardingCoordinator.popToRoot()
      case .main:
        mainCoordinator.popToRoot()
      }
    }
  }
  
  @ViewBuilder
  private var onboardingView: some View {
    NavigationStack(path: $onboardingCoordinator.path) {
      onboardingCoordinator.buildPage(.onboarding1)
        .navigationDestination(for: OnboardingAppPage.self) { page in
          onboardingCoordinator.buildPage(page)
        }
    }
    .environment(onboardingCoordinator)
    .environment(DIContainer.shared.makeOnboardingViewModel())
  }
  
  @ViewBuilder
  private var mainView: some View {
    NavigationStack(path: $mainCoordinator.path) {
      mainCoordinator.buildPage(.today)
        .navigationDestination(for: MainAppPage.self) { page in
          mainCoordinator.buildPage(page)
        }
        .sheet(item: $mainCoordinator.sheet) { sheet in
          mainCoordinator.buildSheet(sheet)
        }
    }
    .environment(mainCoordinator)
  }
}

#Preview {
  CoordinatorView()
}
