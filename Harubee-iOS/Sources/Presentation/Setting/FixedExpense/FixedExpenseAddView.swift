//
//  FixedExpenseAddView.swift
//  Harubee-iOS
//
//  Created by Seo-Jooyoung on 10/30/24.
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import SwiftUI

struct FixedExpenseAddView: View {
  
  @State var fixedExpenseName: String
  @State var fixedExpenseAmount: String
  
  var body: some View {
    Text("고정지출 내역 추가")
      .font(.system(size: 18))
      .padding(.top, 20)
    
    BodyView(fixedExpenseName: $fixedExpenseName, fixedExpenseAmount: $fixedExpenseAmount)
      .padding(.top, 37)
    
    Spacer()
    
    Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
      Text("저장하기")
        .font(.system(size: 18))
        .foregroundStyle(.white)
        .padding(.horizontal, 149)
        .padding(.vertical, 20)
        .background(
          RoundedRectangle(cornerRadius: 10)
            .fill(.purple)
        )
    })
      .padding(.bottom, 9)
  }
}

private struct BodyView: View {
  
  @Binding var fixedExpenseName: String
  @Binding var fixedExpenseAmount: String
  
  @State private var showDayPicker: Bool = false
  @State private var selectedDay: Date = Date()
  
  var body: some View {
    VStack(spacing: 20) {
      HStack(spacing: 0) {
        Text("날짜")
        Spacer()
        DayPickerButton(showDayPicker: $showDayPicker, selectedDay: $selectedDay)
      }
      .padding(.horizontal, 16)
      
      if showDayPicker {
        Picker("날짜 선택", selection: $selectedDay) {
          ForEach(1..<32) { day in
            Text("\(day)일").tag(day)
          }
        }
        .pickerStyle(.wheel)
        .frame(maxWidth: .infinity, maxHeight: 150)
        .padding(.horizontal, 10)
      }
      
      CustomTextfield(title: "이름", text: $fixedExpenseName)
      CustomTextfield(title: "금액", text: $fixedExpenseAmount)
    }
  }
}

private struct DayPickerButton: View {
  @Binding var showDayPicker: Bool
  @Binding var selectedDay: Date
  var body: some View {
    Button {
      showDayPicker.toggle()
    } label: {
      Text("매달 1일")
        .font(.system(size: 16))
        .foregroundStyle(.black)
        .padding(.vertical, 6)
        .padding(.horizontal, 11)
        .background(
          RoundedRectangle(cornerRadius: 6)
            .foregroundStyle(Color.gray)
        )
    }
  }
}

private struct CustomTextfield: View {
  var title: String
  @Binding var text: String
  
  var body: some View {
    VStack(spacing: 0) {
      Text(title)
        .font(.system(size: 12))
        .frame(maxWidth: .infinity, alignment: .leading)
      TextField(title, text: $text)
        .frame(maxWidth: .infinity)
        .font(.system(size: 16))
        .padding(.top, 4)
      Rectangle()
        .frame(height: 1)
        .foregroundStyle(Color.gray)
        .padding(.top, 8)
    }
    .padding(.horizontal, 16)
  }
}

#Preview {
  FixedExpenseAddView(fixedExpenseName: "", fixedExpenseAmount: "")
}
