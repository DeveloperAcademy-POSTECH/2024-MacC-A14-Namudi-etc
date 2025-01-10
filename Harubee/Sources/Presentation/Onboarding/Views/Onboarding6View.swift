//
//  Onboarding6View.swift
//  Harubee-iOS
//
//  Created by Seo-Jooyoung on 11/2/24.
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import SwiftUI

struct Onboarding6View: View {
  @Environment(OnboardingViewModel.self) private var viewModel
  
  var body: some View {
    ZStack {
      Color.main.ignoresSafeArea()
      
      VStack(spacing: 0) {
        titleView
          .padding(.top, 22)
          .padding(.horizontal, 4)
        
        Rectangle()
          .frame(height: 1)
          .foregroundStyle(Color.textBrighter30)
          .padding(.top, 12)
        
        CurrentHarubeeView(harubee: viewModel.state.averageHarubee)
          .padding(.top, 36)
        
        Rectangle()
          .frame(height: 1)
          .foregroundStyle(Color.textBrighter30)
          .padding(.top, 28)
        
        UserInfoView(
          incomeAmount: viewModel.state.incomeAmount ?? 0,
          currentBalance: viewModel.state.currentBalance ?? 0,
          fixedExpenses: viewModel.state.fixedExpenses,
          endDate: viewModel.state.incomeEndDate
        )
        .padding(.top, 26)
        .padding(.horizontal, 4)
        
        Spacer()
        
        OnboardingFooterView(viewModel: viewModel)
          .padding(.bottom, 9)
      }
      .padding(.horizontal, 16)
      
      .frame(maxWidth: .infinity, alignment: .top)
      
    }
    .navigationBarStyle(.onboarding)
  }
  
  
  private var titleView: some View {
    VStack(alignment: .leading, spacing: 0) {
      Text("모든 단계가")
      Text("끝났어요!")
    }
    .font(.pretendardSemibold_30)
    .foregroundStyle(Color.whiteDefault)
    .frame(maxWidth: .infinity, alignment: .leading)
  }
}

private struct CurrentHarubeeView: View {
  let harubee: Int
  
  var body: some View {
    VStack(alignment: .leading, spacing: 6) {
      Text("현재 계산된 하루비")
        .font(.pretendardSemibold_22)
        .padding(.horizontal, 4)
      
      HStack(alignment: .bottom, spacing: 4) {
        Image(.harubeeWhite)
          .resizable()
          .frame(width: 24, height: 24)
          .padding(.bottom, 5)
        Text(harubee.decimalWithWon)
          .font(.pretendardSemibold_30)
      }
      .padding(.horizontal, 4)
      
      Text("(잔액 - 예정된 고정지출) ÷ 다음 주요 수입일까지 남은 일수")
        .font(.pretendardSemibold_14)
        .foregroundStyle(Color.whiteDefault)
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(
          RoundedRectangle(cornerRadius: 10)
            .fill(Color.mainBrighter10)
        )
        .padding(.top, 36)
    }
    .frame(maxWidth: .infinity, alignment: .leading)
    .foregroundStyle(Color.whiteDefault)
  }
}

private struct UserInfoView: View {
  
  private let incomeAmount: Int // 수입 금액
  private let currentBalance: Int // 현재 잔액
  private let fixedExpensesCount: Int // 고정 지출 내역 개수
  private let fixedExpensesTotalAmount: Int // 고정 지출 내역 총합
  private let futureExpensesCount: Int // 예정된 고정지출 내역 개수
  private let futureExpensesTotalAmount: Int // 예정된 고정지출 내역 총합
  private let remainingDays: Int // 남은 기간
  
  init(
    incomeAmount: Int,
    currentBalance: Int,
    fixedExpenses: [TransactionItem],
    endDate: Date
  ) {
    self.incomeAmount = incomeAmount
    self.currentBalance = currentBalance
    
    self.fixedExpensesCount = fixedExpenses.count
    self.fixedExpensesTotalAmount = fixedExpenses.reduce(0) {
      $0 + $1.price
    }
    
    self.futureExpensesCount = fixedExpenses.filter {
      $0.date > .now.formattedDate
    }.count
    
    self.futureExpensesTotalAmount = fixedExpenses
      .filter { $0.date > .now.formattedDate }
      .reduce(0) { $0 + $1.price }
    
    let today = Date().formattedDate
    self.remainingDays = today.daysUntil(endDate) + 1
  }
  
  var body: some View {
    VStack(spacing: 12) {
      UserInfoItemView(
        title: "수입금 중",
        content: incomeAmount.decimalWithWon,
        contentColor: .whiteDeep50
      )
      
      UserInfoItemView(
        title: "현재 잔액",
        content: currentBalance.decimalWithWon
      )
      
      UserInfoItemView(
        title: "고정 지출 (총 \(fixedExpensesCount)건) 중",
        content: "\(fixedExpensesTotalAmount.decimalWithWon)",
        contentColor: .whiteDeep50
      )
      
      UserInfoItemView(
        title: "예정된 고정 지출 (총 \(futureExpensesCount)건)",
        content: "- \(futureExpensesTotalAmount.decimalWithWon)"
      )
      .padding(.leading, 14)
      
      UserInfoItemView(
        title: "다음 수입일까지 남은 기간",
        content: "÷ \(remainingDays)일"
      )
    }
  }
}

private struct UserInfoItemView: View {
  let title: String
  let content: String
  var contentColor: Color = .whiteDefault
  
  var body: some View {
    HStack(spacing: 0) {
      Text(title)
        .font(.pretendardMedium_14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .foregroundStyle(Color.whiteDeep50)
      Text(content)
        .font(.pretendardSemibold_14)
        .foregroundStyle(contentColor)
    }
  }
}

private struct OnboardingFooterView: View {
  @Environment(RootViewSwitcher.self) private var rootViewSwitcher
  let viewModel: OnboardingViewModel
  
  var body: some View {
    VStack(spacing: 0) {
      Text("입력한 정보들은 설정에서 언제든지 수정할 수 있어요")
        .font(.pretendardMedium_12)
        .foregroundStyle(Color.whiteDeep50)
      
      Button {
        viewModel.send(.finishOnboardingSetting)
        
        rootViewSwitcher.switchRootView()
      } label: {
        HStack {
          Text("하루비 시작하기")
            .font(.pretendardSemibold_18)
            .foregroundStyle(Color.main)
            .padding(.vertical, 20)
        }
        .frame(maxWidth: .infinity)
        .background(Color.whiteDefault)
        .clipShape(
          RoundedRectangle(cornerRadius: 10)
        )
      }
      .buttonStyle(CustomButtonStyle(
        haptic: .success
      ))
      .padding(.top, 10)
      .padding(.bottom, 9)
      .padding(.horizontal, 16)
    }
  }
}

#Preview {
  Onboarding6View()
    .environment(RootViewSwitcher())
    .environment(DIContainer.shared.makeOnboardingViewModel())
}
