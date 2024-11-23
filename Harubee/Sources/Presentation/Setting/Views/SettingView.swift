//
//  SettingView.swift
//  Harubee-iOS
//
//  Created by namdghyun on 10/28/24.
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import SwiftUI

struct SettingView: View {
  @State private var settingViewModel: SettingViewModel
  
  @State var harubeeSelectedTime: Date
  @State var expenseSelectedTime: Date
  @State var harubeeNotificationStatus: Bool
  @State var expenseNotificationStatus: Bool
  
  @State private var showHarubeeTimePicker: Bool = false
  @State private var showExpenseTimePicker: Bool = false
  @State private var navigateFixedExpense: Bool = false
  @State private var navigateFixedIncome: Bool = false
  
  private var salaryBudget: SalaryBudget? {
    settingViewModel.state.salaryBudget
  }
  
  init(settingViewModel: SettingViewModel) {
    self.settingViewModel = settingViewModel
    harubeeSelectedTime = settingViewModel.state.harubeeNotificationTime!
    expenseSelectedTime = settingViewModel.state.expenseNotificationTime!
    harubeeNotificationStatus = settingViewModel.state.harubeeNotificationStatus!
    expenseNotificationStatus = settingViewModel.state.expenseNotificationStatus!
  }
  
  var body: some View {
    
    NavigationHeaderView(
      harubeeSelectedTime: $harubeeSelectedTime,
      expenseSelectedTime: $expenseSelectedTime,
      showHarubeeTimePicker: $showHarubeeTimePicker,
      showExpenseTimePicker: $showExpenseTimePicker,
      settingViewModel: settingViewModel
    )
    
    ScrollView {
      VStack(spacing: 6) {
        
        SettingNotificationView(
          harubeeSelectedTime: $harubeeSelectedTime,
          expenseSelectedTime: $expenseSelectedTime,
          harubeeNotificationStatus: $harubeeNotificationStatus,
          expenseNotificationStatus: $expenseNotificationStatus,
          showHarubeeTimePicker: $showHarubeeTimePicker,
          showExpenseTimePicker: $showExpenseTimePicker
        )
        
        SectionContainer {
          SettingItem(
            title: "고정지출 관리",
            previewText: "총 \(salaryBudget?.fixedExpenses.count ?? 0)건 / \(salaryBudget?.fixedExpenses.reduce(0) { $0 + $1.price }.decimalWithWon ?? 0.decimalWithWon)"
          )
          .onTapGesture { navigateFixedExpense = true }
          .navigationDestination(
            isPresented: $navigateFixedExpense
          ) {
            FixedExpenseView(settingViewModel: settingViewModel)
          }
          
          SettingItem(
            title: "고정수입 관리",
            previewText: "매달 \(salaryBudget?.startDate.formattedDateToString(.day_kr) ?? "1일") / \(salaryBudget?.fixedIncome.decimalWithWon ?? "")"
          )
          .onTapGesture { navigateFixedIncome = true }
          .navigationDestination(
            isPresented: $navigateFixedIncome
          ) {
            FixedIncomeView(settingViewModel: settingViewModel)
          }
        }
        
        settingFooterView
      }
      .background(.textBlack5)
      .onChange(of: harubeeNotificationStatus) { _, newValue in
        settingViewModel.send(
          .toggleNotificationStatus(.harubee, newValue)
        )
      }
      .onChange(of: expenseNotificationStatus) { _, newValue in
        settingViewModel.send(
          .toggleNotificationStatus(.expense, newValue)
        )
      }
    }
    .ignoresSafeArea()
    .toolbar(.hidden)
    .scrollIndicators(.hidden)
    .font(.pretendardMedium_18)
    .foregroundStyle(Color.textBlack)
  }
  
  private var settingFooterView: some View {
    SectionContainer {
      VStack(alignment: .leading, spacing: 6) {
        Text("앱 버전")
          .font(.pretendardSemibold_18)
          .foregroundStyle(Color.textBlack)
        
        Text("v\(Bundle.main.shortVersionString)")
          .font(.pretendardMedium_14)
          .foregroundStyle(Color.textBlack30)
      }.frame(maxWidth: .infinity, alignment: .leading)
      
      Text("현재 1.0.1")
        .font(.pretendardMedium_14)
        .foregroundStyle(Color.textBlack30)
    }
    .frame(maxWidth: .infinity, alignment: .leading)
    .padding(.horizontal, 18)
    .padding(.vertical, 32)
    .background(Color.whiteDefault)
  }
}

// MARK: - NavigationHeaderView
private struct NavigationHeaderView: View {
  @Environment(\.dismiss) private var dismiss
  @State private var isShowAlert: Bool = false
  
  @Binding var harubeeSelectedTime: Date
  @Binding var expenseSelectedTime: Date
  @Binding var showHarubeeTimePicker: Bool
  @Binding var showExpenseTimePicker: Bool
  let settingViewModel: SettingViewModel
  
  var body: some View {
    HStack {
      backButton
        .tapFeedback(haptic: .none) {
          let initialHarubeeTime = settingViewModel.state.harubeeNotificationTime
          let initialExpenseTime = settingViewModel.state.expenseNotificationTime
          
          // 기존에 설정한 알림시간 설정과 다르고 열려있지 않다면
          if initialHarubeeTime != harubeeSelectedTime
              && showHarubeeTimePicker == false {
            // 바뀐시간으로 저장하기
            settingViewModel.send(
              .updateNotificationTime(.harubee, harubeeSelectedTime)
            )
            
            dismiss()
            
            // 기존에 설정한 알림시간 설정과 다르고 열려있다면
          } else if initialHarubeeTime != harubeeSelectedTime
                      && showHarubeeTimePicker == true {
            isShowAlert = true
          }
          
          if initialExpenseTime != expenseSelectedTime
              && showExpenseTimePicker == false {
            
            settingViewModel.send(
              .updateNotificationTime(.expense, expenseSelectedTime)
            )
            
            dismiss()
            
          } else if initialExpenseTime != expenseSelectedTime
                      && showExpenseTimePicker == true {
            isShowAlert = true
          }
        }
      
      Spacer()
      
      Text("설정")
        .foregroundStyle(.textBlack)
        .font(.pretendardSemibold_18)
      
      Spacer()
      
      backButton.hidden()
    }
    .tint(.main)
    .padding(EdgeInsets(
      top: 5, leading: 16, bottom: 11, trailing: 16)
    )
    .alert(
      "알림 설정을 마무리할까요?",
      isPresented: $isShowAlert
    ) {
      Button(role: .cancel) {
        dismiss()
      } label: {
        Text("취소")
      }

      Button {
        
        settingViewModel.send(
          .updateNotificationTime(
            showHarubeeTimePicker ? .harubee : .expense,
            showHarubeeTimePicker ? harubeeSelectedTime : expenseSelectedTime)
        )
        
        dismiss()
      } label: {
        Text("확인")
      }
    } message: {
      if showHarubeeTimePicker {
        Text(
          "오늘의 하루비 알림이\n'매일 \(harubeeSelectedTime.formattedToTimeString)'로 변경돼요."
        )
      } else {
        Text("실제 지출 입력 알림이\n'매일 \(expenseSelectedTime.formattedToTimeString)'로 변경돼요.")
      }
    }
  }
  
  private var backButton: some View {
    HStack(alignment: .center, spacing: 0) {
      Image(systemName: "chevron.left")
        .resizable()
        .frame(width: 10, height: 18)
        
      Text("뒤로")
        .padding(.leading, 6)
        .font(.pretendardMedium_18)
    }
    .foregroundStyle(.main)
  }
}

// MARK: - SettingNotificationView
private struct SettingNotificationView: View {
  
  @Binding var harubeeSelectedTime: Date
  @Binding var expenseSelectedTime: Date
  @Binding var harubeeNotificationStatus: Bool
  @Binding var expenseNotificationStatus: Bool
  @Binding var showHarubeeTimePicker: Bool
  @Binding var showExpenseTimePicker: Bool
  
  var body: some View {
    VStack(spacing: 24) {
      TimePickerView(
        title: "오늘의 하루비 알림",
        isToggleOn: $harubeeNotificationStatus,
        selectedTime: $harubeeSelectedTime,
        showPicker: $showHarubeeTimePicker
      )
      
      TimePickerView(
        title: "실제 지출 입력 알림",
        isToggleOn: $expenseNotificationStatus,
        selectedTime: $expenseSelectedTime,
        showPicker: $showExpenseTimePicker
      )
    }
    .padding(.top, 40)
    .padding(.bottom, 27)
    .background(Color.whiteDefault)
    .shadow(color: Color.textBlack5, radius: 3, x: 0, y: 1)
    .onChange(of: showExpenseTimePicker) {
      if showExpenseTimePicker && showHarubeeTimePicker  {
        showHarubeeTimePicker = false
      }
    }
    .onChange(of: showHarubeeTimePicker) {
      if showHarubeeTimePicker && showExpenseTimePicker {
        showExpenseTimePicker = false
      }
    }
  }
}

// MARK: - SettingItem
private struct SettingItem: View {
  let title: String
  let previewText: String
  
  var body: some View {
    HStack(alignment: .center, spacing: 8) {
      Text(title)
        .font(.pretendardSemibold_18)
        .foregroundStyle(Color.textBlack)
      
      Spacer()
      
      Text(previewText)
        .font(.pretendardMedium_16)
        .foregroundStyle(Color.main)
      
      Image(systemName: "chevron.right")
        .font(Font.system(size: 16, weight: .regular))
        .foregroundStyle(Color.textBlack)
        .frame(width: 12, height: 19)
    }
  }
}


// MARK: - SectionContainer
private struct SectionContainer<Content: View>: View {
  private let content: () -> Content
  
  init(@ViewBuilder content: @escaping () -> Content) {
    self.content = content
  }
  
  var body: some View {
    VStack(spacing: 34) {
      content()
    }
    .padding(EdgeInsets(top: 32, leading: 18, bottom: 32, trailing: 18))
    .frame(maxWidth: .infinity)
    .background(Color.whiteDefault)
    .shadow(color: Color.textBlack5, radius: 3, x: 0, y: 1)
  }
}

#Preview {
  SettingView(
    settingViewModel: DIContainer.shared.makeSettingViewModel(
      salaryBudget: SalaryBudget.default
    )
  )
}
