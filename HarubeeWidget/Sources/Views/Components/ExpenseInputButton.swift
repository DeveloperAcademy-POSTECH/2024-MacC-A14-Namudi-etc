//
//  ExpenseInputButton.swift
//  HarubeeWidgetExtension
//
//  Created by 이정동 on 11/22/24.
//

import SwiftUI

// MARK: - ExpenseInputButton
struct ExpenseInputButton: View {
  let title: String
  
  var body: some View {
    Link(destination: WidgetURL.transactionInput.url) {
      Text(title)
        .font(.pretendardSemibold_12)
        .foregroundStyle(.whiteDefault)
        .frame(maxWidth: .infinity)
        .padding(.vertical, 13)
        .background(.main)
        .clipShape(RoundedRectangle(cornerRadius: 25))
    }
  }
}
