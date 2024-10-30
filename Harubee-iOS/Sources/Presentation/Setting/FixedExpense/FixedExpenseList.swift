//
//  FixedExpenseList.swift
//  Harubee-iOS
//
//  Created by Seo-Jooyoung on 10/29/24.
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import SwiftUI

struct FixedExpenseList: View {
  @State private var items: [String] = ["지출 항목 1", "지출 항목 2"]
  var body: some View {
    VStack(spacing: 0) {
      BodyView(items: $items)
    }
  }
  
  private func addItem() {
    items.append("지출 항목 \(items.count + 1)")
  }
}

private struct BodyView: View {
  @Binding var items: [String]
  
  var body: some View {
    VStack(spacing: 0) {
      ForEach(items.indices, id: \.self) { index in
        ListItemView(fixedExpenseName: items[index], fixedExpenseAmount: items[index])
        
        if index < items.count - 1 {
          Divider()
            .foregroundStyle(Color.gray)
        }
      }
    }
    .background(
      ZStack {
        RoundedRectangle(cornerRadius: 5)
          .stroke(lineWidth: 1)
          .foregroundStyle(Color.gray)
        RoundedRectangle(cornerRadius: 5)
          .fill(Color.white)
      }
    )
    .padding(.horizontal, 16)
  }
}

private struct ListItemView: View {
  @State var fixedExpenseName: String
  @State var fixedExpenseAmount: String
  
  var body: some View {
    Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
      HStack(spacing: 0) {
        Text("매달 12일")
          .font(.system(size: 16))
          .foregroundStyle(.black)
          .padding(.vertical, 6)
          .padding(.horizontal, 11)
          .background(
            RoundedRectangle(cornerRadius: 6)
              .foregroundStyle(Color.gray)
          )
        
        Spacer()
        
        Text("청약")
          .font(.system(size: 20))
          .foregroundStyle(.black)
          .padding(.trailing, 10)
        Text("100,000원")
          .font(.system(size: 18, weight: .semibold))
          .foregroundStyle(.black)
          .padding(.trailing, 6)
      }
      .padding(.vertical, 10)
      .padding(.horizontal, 6)
    })
  }
}
  // 다른 뷰로 옮겨갈 예정
private struct FixedExpenseInputTextfield: View {
  var title: String
  @Binding var text: String
  
  var body: some View {
    VStack(spacing: 4) {
      TextField(title, text: $text)
        .frame(maxWidth: .infinity)
      Rectangle()
        .frame(height: 1)
        .foregroundStyle(Color.gray)
    }
  }
}

  #Preview {
    FixedExpenseList()
  }

