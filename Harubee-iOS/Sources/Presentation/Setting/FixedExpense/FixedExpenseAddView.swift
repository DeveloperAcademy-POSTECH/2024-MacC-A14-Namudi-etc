//
//  FixedExpenseAddView.swift
//  Harubee-iOS
//
//  Created by Seo-Jooyoung on 10/30/24.
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import SwiftUI
import DesignSystem

struct FixedExpenseAddView: View {
  
  @State var fixedExpenseName: String
  @State var fixedExpenseAmount: String
  
  var body: some View {
    VStack(spacing: 0) {
      Text("고정지출 내역 추가")
        .font(.pretendardMedium_18)
        .padding(.top, 20)
      
      BodyView(fixedExpenseName: $fixedExpenseName, fixedExpenseAmount: $fixedExpenseAmount)
        .padding(.top, 37)
      
      Spacer()
      
      Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
        Text("저장하기")
          .font(.pretendardSemibold_18)
          .foregroundStyle(Color.whiteDeep)
          .padding(.horizontal, 149)
          .padding(.vertical, 20)
          .background(
            RoundedRectangle(cornerRadius: 10)
              .fill(Color.main)
            // textfield 다 안 채워지면 Main_30
          )
      })
      .padding(.bottom, 9)
    }
  }
}

private struct BodyView: View {
  
  @Binding var fixedExpenseName: String
  @Binding var fixedExpenseAmount: String
  
  var body: some View {
    VStack(spacing: 20) {
      DayPickerView()
      
      FloatingTitleTextField(title: "이름", text: $fixedExpenseName)
      FloatingTitleTextField(title: "금액", text: $fixedExpenseAmount)
    }
  }
}

#Preview {
  FixedExpenseAddView(fixedExpenseName: "", fixedExpenseAmount: "")
}
