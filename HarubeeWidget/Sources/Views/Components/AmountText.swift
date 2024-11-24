//
//  AmountText.swift
//  HarubeeWidgetExtension
//
//  Created by 이정동 on 11/24/24.
//

import SwiftUI

struct AmountText: View {
  let amount: Int
  
  var body: some View {
    Text(
      amount >= 100000
      ? amount.formattedAsTenThousandWon
      : amount.decimal
    )
  }
}
