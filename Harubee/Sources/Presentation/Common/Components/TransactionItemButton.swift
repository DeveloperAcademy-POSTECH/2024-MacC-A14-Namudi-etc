//
//  TransactionItemButton.swift
//  Harubee-iOS
//
//  Created by 이정동 on 10/31/24.
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import SwiftUI

struct TransactionItemButton: View {
  
  let title: String
  let amount: Int?
  var textColor: Color = .textBlack
  var backgroundColor: Color = .textBrighter30
  
  var body: some View {
    VStack(spacing: 16) {
      Text(title)
        .font(.pretendardSemibold_16)
        .foregroundStyle(textColor)
        .frame(maxWidth: .infinity, alignment: .leading)
      
      Text(amount?.decimalWithWon ?? "- 원")
        .font(.pretendardSemibold_18)
        .foregroundStyle(textColor)
        .frame(maxWidth: .infinity, alignment: .trailing)
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
