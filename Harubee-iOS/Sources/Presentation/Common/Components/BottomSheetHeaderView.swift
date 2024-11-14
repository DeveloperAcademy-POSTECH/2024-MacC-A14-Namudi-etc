//
//  BottomSheetHeaderView.swift
//  Harubee-iOS
//
//  Created by 이정동 on 10/31/24.
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import SwiftUI

struct BottomSheetHeaderView: View {
  @Environment(\.dismiss) private var dismiss
  
  private let title: String
  private let isDisplayCloseButton: Bool
  
  init(
    title: String,
    isDisplayCloseButton: Bool = true
  ) {
    self.title = title
    self.isDisplayCloseButton = isDisplayCloseButton
  }
  
  var body: some View {
    ZStack {
      HStack {
        Button {
          dismiss()
        } label: {
          Text("취소")
            .font(.pretendardMedium_18)
            .foregroundStyle(Color.main)
        }

      }
      .frame(maxWidth: .infinity, alignment: .leading)
      
      Text(title)
        .font(.pretendardSemibold_18)
        .foregroundStyle(Color.textBlack)
    }
    .padding(.horizontal, 16)
    .padding(.top, 20)
  }
}

#Preview {
  BottomSheetHeaderView(title: "하루비 조정")
}
