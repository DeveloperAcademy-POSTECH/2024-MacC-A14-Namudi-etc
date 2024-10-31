//
//  HarubeeAdjustView.swift
//  Harubee-iOS
//
//  Created by 이정동 on 10/31/24.
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import SwiftUI
import Core
import DesignSystem

// MARK: - HarubeeAdjustView
struct HarubeeAdjustView: View {
  
  @State private var hightlightLabelAmount: Int = 62000
  
  @State private var isUpdated: Bool = false
  
  // TODO: SalaryBudget, InitialHarubee 저장
  
  var body: some View {
    VStack {
      BottomSheetHeaderView(title: "하루비 조정")
      
      HarubeeAdjustBodyView(
        isUpdated: $isUpdated,
        defaultHarubee: $hightlightLabelAmount
      )
      .padding(.horizontal, 22)
      .padding(.top, 36)
      
      Spacer()
      
      AmountTextView(
        numberText: .constant("test"),
        isUpdated: $isUpdated
      )
        .padding(.horizontal, 37)
      
      MainColorButton(
        title: "저장하기",
        isEnabled: $isUpdated
      ) {
          print("저장하기 Tap")
        }
      
      NumberKeypadView(text: .constant("test"))
    }
    .frame(maxWidth: .infinity)
  }
}

// MARK: - HarubeeAdjustBodyView
private struct HarubeeAdjustBodyView: View {
  
  @Binding private var isUpdated: Bool
  @Binding private var defaultHarubee: Int
  
  init(isUpdated: Binding<Bool>, defaultHarubee: Binding<Int>) {
    self._isUpdated = isUpdated
    self._defaultHarubee = defaultHarubee
  }
  
  var body: some View {
    VStack(alignment: .leading, spacing: 0) {
      
      if isUpdated {
        Text("하루비 조정 후 계산된")
          .font(.pretendardMedium_18)
          .foregroundStyle(Color.textBlack)
          .padding(.top, 3)
      }
      
      HighlightDefaultHarubeeLabel(
        title: isUpdated ? "기본 하루비는" : "현재 기본 하루비는",
        amount: defaultHarubee
      )
      .padding(.top, isUpdated ? 6 : 0)
      
      if !isUpdated {
        VStack(alignment: .leading, spacing: 2) {
          Text("기본 하루비는 하루비 조정을 하지 않은 날짜에")
          Text("자동으로 분배되는 하루비를 의미해요.")
        }
        .padding(.top, 14)
        .font(.pretendardMedium_14)
        .foregroundStyle(Color.textBlack30)
      }
    }
    .frame(maxWidth: .infinity, alignment: .leading)
    
  }
}

// MARK: -
private struct AmountTextView: View {
  
  @Binding private var numberText: String
  @Binding private var isUpdated: Bool
  
  init(numberText: Binding<String>, isUpdated: Binding<Bool>) {
    self._numberText = numberText
    self._isUpdated = isUpdated
  }
  
  var body: some View {
    
    HStack(spacing: 10) {
      HStack(spacing: 0) {
        Text(numberText)
        Text("원")
      }
      .font(.pretendardSemibold_40)
      
      Button {
        
      } label: {
        Image(systemName: "arrow.trianglehead.counterclockwise")
          .font(.system(size: 32, weight: .bold))
      }

    }
    .frame(maxWidth: .infinity, alignment: .trailing)
    .foregroundStyle(Color.main)
    
  }
}

// MARK: - HighlightDefaultHarubeeLabel
private struct HighlightDefaultHarubeeLabel: View {
  
  private let title: String
  private let amount: Int
  
  init(title: String, amount: Int) {
    self.title = title
    self.amount = amount
  }
  
  var body: some View {
    HStack(alignment: .bottom, spacing: 0) {
      Text(title)
        .font(.pretendardMedium_18)
      
      Text(amount.decimalWithWon)
        .font(.pretendardSemibold_22)
        .padding(.leading, 6)
      
      Text("입니다")
        .font(.pretendardMedium_18)
    }
    .foregroundStyle(Color.textBlack)
  }
}

// MARK: - Preview
#Preview {
  HarubeeAdjustView()
}
