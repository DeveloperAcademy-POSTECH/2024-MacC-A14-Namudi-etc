//
//  SettingView.swift
//  Harubee-iOS
//
//  Created by namdghyun on 10/28/24.
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import SwiftUI

struct SettingView: View {
  @Environment(MainCoordinator.self) private var coordinator
  @State var settingViewModel: SettingViewModel
  
  var body: some View {
    ZStack(alignment: .top) {
      Color.bgPrimary.ignoresSafeArea()
      
      ScrollView {
        // 알림 설정
        NotificationManageView(settingViewModel: settingViewModel)
        
        SectionDivider()
        
        // 고정 지출, 수입 관리
        FixedAmountManageView(settingViewModel: settingViewModel)
        
        SectionDivider()
        
        // 언어, 통화, 화면 테마 설정
        PreferencesSettingsView(settingViewModel: settingViewModel)
        
        SectionDivider()
        
        // 문의하기, 개발 로드맵, 앱 버전
        SettingInformationView(settingViewModel: settingViewModel)
        
        SectionDivider()
        
        // 데이터 초기화
        DataResetView(settingViewModel: settingViewModel)
      }.scrollIndicators(.hidden)
    }
    .navigationBarStyle(.white(title: "설정", backTitle: "뒤로"))
  }
}

// MARK: - NotificationManageView
private struct NotificationManageView: View {
  let settingViewModel: SettingViewModel
  
  @State private var showHarubeePicker: Bool = false
  @State private var showExpensePicker: Bool = false

  var body: some View {
    SectionContainer(spacing: 24) {
      TimePickerView(
        title: "오늘의 하루비 알림",
        isToggleOn: settingViewModel.binding(.harubeeNotificationStatus),
        selectedTime: settingViewModel.binding(.harubeeNotificationTime),
        showPicker: $showHarubeePicker
      )

      TimePickerView(
        title: "실제 지출 입력 알림",
        isToggleOn: settingViewModel.binding(.expenseNotificationStatus),
        selectedTime: settingViewModel.binding(.expenseNotificationTime),
        showPicker: $showExpensePicker
      )
    }
    .onChange(of: showHarubeePicker) {
      if showHarubeePicker && showExpensePicker {
        showExpensePicker = false
      }
    }
    .onChange(of: showExpensePicker) {
      if showHarubeePicker && showExpensePicker {
        showHarubeePicker = false
      }
    }
  }
}

// MARK: - FixedAmountManageView
private struct FixedAmountManageView: View {
  @Environment(MainCoordinator.self) private var coordinator
  let settingViewModel: SettingViewModel
  
  private var salaryBudget: SalaryBudget {
    settingViewModel.state.salaryBudget
  }
  
  var body: some View {
    SectionContainer {
      Button {
        coordinator.push(.fixedExpense(
          settingViewModel: settingViewModel
        ))
      } label: {
        SectionItem(
          title: "고정지출 관리",
          previewText: "총 \(salaryBudget.fixedExpenses.count)건 / \(salaryBudget.fixedExpenses.reduce(0) { $0 + $1.price }.decimalWithWon)"
        )
      }
      
      Button {
        coordinator.push(.fixedIncome(
          settingViewModel: settingViewModel
        ))
      } label: {
        SectionItem(
          title: "고정수입 관리",
          previewText: "매달 \(salaryBudget.startDate.formattedDateToString(.day_kr)) / \(salaryBudget.fixedIncome.decimalWithWon)"
        )
      }
    }
  }
}

// MARK: - PreferencesSettingsView
private struct PreferencesSettingsView: View {
  @Environment(MainCoordinator.self) private var coordinator
  @AppStorage("appearance") var appearnace: AppearanceType = .automatic
  let settingViewModel: SettingViewModel
  
  var body: some View {
    Button {
      coordinator.push(.appearanceOptions)
    } label: {
      SectionContainer {
        SectionItem(title: "화면 테마 설정", previewText: appearnace.name)
      }
    }
  }
}


// MARK: - SettingInformationView
private struct SettingInformationView: View {
  @Environment(\.openURL) var openURL
  let settingViewModel: SettingViewModel
  let email: String = "contact@harubee.app"
  
  var body: some View {
    SectionContainer {
      Button {
        settingViewModel.send(.contactButtonTapped(openURL, email))
      } label: {
        SectionItem(title: "문의하기", previewText: "")
      }
      
      /*
      Button {
        
      } label: {
        SectionItem(title: "개발 로드맵", previewText: "")
      }
      */
      
      appVersionSection
    }
  }
  
  private var appVersionSection: some View {
    VStack(alignment: .leading, spacing: 6) {
      Text("앱 버전")
        .font(.pretendardSemibold_18)
        .foregroundStyle(.textPrimary)
      
      Text("v\(Bundle.main.shortVersionString)")
        .font(.pretendardMedium_14)
        .foregroundStyle(.textPrimary30)
    }
    .frame(maxWidth: .infinity, alignment: .leading)
  }
}

// MARK: - DataResetView
private struct DataResetView: View {
  @Environment(RootViewSwitcher.self) private var rootViewSwitcher
  let settingViewModel: SettingViewModel
  @State private var isAlertPresented: Bool = false
  
  var body: some View {
    SectionContainer {
      Button {
        isAlertPresented = true
        HapticManager.shared.trigger(.warning)
      } label: {
        Text("데이터 초기화")
          .foregroundStyle(.warning)
          .font(.pretendardSemibold_18)
      }
      .frame(maxWidth: .infinity, alignment: .leading)
    }
    .alert(
      "데이터를 초기화 하시겠어요?",
      isPresented: $isAlertPresented
    ) {
      Button(role: .cancel) {
      } label: {
        Text("취소")
      }

      Button(role: .destructive) {
        settingViewModel.send(.resetDataButtonTapped)
        rootViewSwitcher.switchRootView()
      } label: {
        Text("확인")
      }
    } message: {
      Text("앱에 저장된 모든 데이터가 초기화됩니다.")
    }
  }
}

// MARK: - SectionDivider
private struct SectionDivider: View {
  
  var body: some View {
    Rectangle()
      .frame(maxWidth: .infinity, maxHeight: 6)
      .foregroundStyle(
        .textPrimary5.shadow(.inner(radius: 3, x: 0, y: 1))
      )
  }
}

// MARK: - SectionContainer
private struct SectionContainer<Content: View>: View {
  private let spacing: CGFloat
  private let content: () -> Content
  
  init(
    spacing: CGFloat = 34,
    @ViewBuilder content: @escaping () -> Content
  ) {
    self.content = content
    self.spacing = spacing
  }
  
  var body: some View {
    VStack(spacing: spacing) {
      content()
    }
    .padding(EdgeInsets(top: 32, leading: 18, bottom: 32, trailing: 18))
    .frame(maxWidth: .infinity)
  }
}

// MARK: - SettingItem
private struct SectionItem: View {
  let title: String
  let previewText: String
  
  var body: some View {
    HStack(alignment: .center, spacing: 8) {
      Text(title)
        .font(.pretendardSemibold_18)
        .foregroundStyle(.textPrimary)
      
      Spacer()
      
      Text(previewText)
        .font(.pretendardMedium_16)
        .foregroundStyle(.mainText)
      
      Image(systemName: "chevron.right")
        .font(Font.system(size: 16, weight: .regular))
        .foregroundStyle(.textPrimary)
        .frame(width: 12, height: 19)
    }
  }
}


// MARK: - Preview
#Preview {
  SettingView(
    settingViewModel: DIContainer.shared.makeSettingViewModel(
      salaryBudget: SalaryBudget.default
    )
  )
  .environment(MainCoordinator())
  .environment(RootViewSwitcher())
}
