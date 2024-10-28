//
//  FixedExpenseInputCell.swift
//  Harubee-iOS
//
//  Created by Seo-Jooyoung on 10/28/24.
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import SwiftUI

struct FixedExpenseInputCell: View {
  @State var fixedExpenseName: String
  @State var fixedExpenseAmount: String
  
  var body: some View {
    HStack(spacing: 8){
      DeleteButton()
      DateButton()
      FixedExpenseInputTextfield(title: "지출 이름", text: $fixedExpenseName)
      FixedExpenseInputTextfield(title: "지출 금액", text: $fixedExpenseAmount)
    }
    .padding(.horizontal, 20)
  }
}

private struct DeleteButton: View {
  var body: some View {
    Button(action: {
      print("Delete Cell")
    }, label: {
      ZStack {
        Circle()
          .fill(.gray)
        
        Image(systemName: "minus")
          .frame(width: 15, height: 15)
          .foregroundStyle(Color.white)
      }
      .frame(width: 25, height: 25)
    })
  }
}

private struct DateButton: View {
  var body: some View {
    Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
      ZStack {
        Capsule()
          .fill(Color.purple)
        Text("1일")
          .font(.system(size: 12))
          .foregroundStyle(Color.white)
          .padding(.horizontal, 12)
          .padding(.vertical, 6)
      }
      .frame(width: 50, height: 27)
    })
  }
}

private struct FixedExpenseInputTextfield: View {
  var title: String
  @Binding var text: String
  
  var body: some View {
    TextField(title, text: $text)
      .padding(.horizontal, 12)
      .padding(.vertical, 8)
      .background(Color.gray)
      .clipShape(RoundedRectangle(cornerRadius: 7))
  }
}

#Preview {
  FixedExpenseInputCell(fixedExpenseName: "", fixedExpenseAmount: "")
}
