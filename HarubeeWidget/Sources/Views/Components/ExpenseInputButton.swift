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
      ViewThatFits {
        Text(title)
          .padding(.horizontal, 18)
          
        Text(title)
          .padding(.horizontal, 13)
      }
    }
    .font(.pretendardSemibold_12)
    .foregroundStyle(.textFixed)
    .padding(.vertical, 13)
    .background(.mainPrimary)
    .clipShape(RoundedRectangle(cornerRadius: 25))
  }
}

// MARK: - Preview
import WidgetKit
#Preview("SystemMedium", as: .systemMedium) {
  HarubeeWidget()
} timeline: {
  HarubeeWidgetEntry(
    date: .now,
    salaryBudget: SalaryBudget.default
  )
}
