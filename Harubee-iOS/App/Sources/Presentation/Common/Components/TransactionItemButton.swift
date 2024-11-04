//
//  TransactionItemButton.swift
//  Harubee-iOS
//
//  Created by 이정동 on 10/31/24.
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import SwiftUI
import Shared

struct TransactionItemButton: View {
  
  private let title: String
  private let amount: Int
  private let textColor: Color
  private let backgroundColor: Color
  
  init(
    title: String,
    amount: Int,
    textColor: Color = Color.textBlack,
    backgroundColor: Color = Color.textBrighter30
  ) {
    self.title = title
    self.amount = amount
    self.textColor = textColor
    self.backgroundColor = backgroundColor
  }
  
  var body: some View {
    VStack(spacing: 16) {
      Text(title)
        .font(.pretendardSemibold_16)
        .foregroundStyle(textColor)
        .frame(maxWidth: .infinity, alignment: .leading)
      
      Text(amount.decimalWithWon)
        .font(.pretendardSemibold_18)
        .foregroundStyle(textColor)
        .frame(maxWidth: .infinity, alignment: .trailing)
        .padding(.top, 16)
    }
    .padding(14)
    .background(backgroundColor)
    .clipShape(RoundedRectangle(cornerRadius: 5))
    
  }
}

#Preview {
  TransactionItemButton(
    title: "수입",
    amount: 1000,
    textColor: Color.textBlack,
    backgroundColor: Color.textBrighter30
  )
}
