//
//  FixedIncomeView.swift
//  Data
//
//  Created by Seo-Jooyoung on 10/31/24.
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import SwiftUI
import DesignSystem

struct FixedIncomeView: View {
  @State private var selectedDay: Int = 1
  var body: some View {
    VStack(spacing: 48) {
      HeaderView()
      BodyView(selectedDay: $selectedDay)
    }
    .frame(maxHeight: .infinity, alignment: .top)
  }
}

private struct HeaderView: View {
  var body: some View {
    VStack(spacing: 4) {
      VStack(alignment: .leading, spacing: 10) {
        Text("고정수입 날짜를 기준으로")
        Text("하루비를 알려드릴게요.")
      }
      .foregroundStyle(Color.textBlack)
      .frame(maxWidth: .infinity, alignment: .leading)
      .padding(.horizontal, 4)
      
      Rectangle()
        .frame(height: 1)
        .foregroundStyle(Color.textBrighter30)
    }
    .font(.pretendardSemibold_22)
    .padding(.horizontal, 16)
    .padding(.top, 44)
  }
}

private struct BodyView: View {
  @Binding var selectedDay: Int
  @State private var showingSheet: Bool = false
  
  var body: some View {
    VStack(spacing: 30) {
      DayPickerView(title: "주요 고정수입 날짜", selectedDay: $selectedDay)
      
      HStack(spacing: 0) {
        Text("금액")
          .font(.pretendardMedium_18)
        
        Spacer()
        
        Button {
          showingSheet.toggle()
        } label: {
          HStack(spacing: 2) {
            Text("100,000원")
              .font(.pretendardMedium_20)
            Image(systemName: "pencil")
              .frame(width: 21, height: 24)
          }
          .foregroundStyle(Color.textBlack)
        }
        .sheet(isPresented: $showingSheet) {
          FixedIncomeModifyView()
            .presentationDetents([.fraction(0.6)])
            .presentationCornerRadius(20)
        }
      }
      .padding(.horizontal, 20)
    }
  }
}

private struct FixedIncomeModifyView: View {
  @State private var fixedIncomeAmount: String = ""

  var body: some View {
    VStack(spacing: 0) {
      Text("금액")
        .font(.pretendardMedium_18)
        .foregroundStyle(Color.textBlack)
        .padding(.top, 20)
      
      FloatingTitleTextField(title: "금액", text: $fixedIncomeAmount)
        .padding(.top, 38)
      
      Button {
        print(fixedIncomeAmount)
      } label: {
        Text("저장하기")
          .font(.pretendardMedium_18)
          .padding(.vertical, 20)
          .frame(maxWidth: .infinity)
          .foregroundStyle(Color.whiteDefault)
          .background(Color.main)
      }
      .padding(.top, 24)
      
      NumberKeypadView(text: $fixedIncomeAmount)
        .padding(.top, 26)
        .padding(.horizontal, 16)
        .padding(.bottom, 31)
    }
    .ignoresSafeArea()
  }
}

#Preview {
  FixedIncomeView()
}
