//
//  SelectionPickerView.swift
//  Harubee
//
//  Created by 신승재 on 1/15/25.
//

import SwiftUI

struct SelectionPickerView<Option: Hashable & Identifiable>: View {
  let options: [Option]
  @Binding var selectedOption: Option
  let optionFormatter: (Option) -> String
  
  var body: some View {
    List {
      Picker("", selection: $selectedOption) {
        ForEach(options) { option in
          Text(optionFormatter(option))
            .font(.pretendardMedium_18)
            .foregroundStyle(.textPrimary)
            .padding(.vertical, 9)
            .tag(option)
        }
      }
      .pickerStyle(.inline)
      .labelsHidden()
      .listRowBackground(Color.clear)
      .listSectionSeparator(.hidden)
    }
    .padding(.top, 24)
    .tint(.mainPrimary)
    .listStyle(.plain)
    .scrollBounceBehavior(.basedOnSize)
  }
}
