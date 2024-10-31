//
//  DailyMemoAddView.swift
//  Harubee-iOS
//
//  Created by Seo-Jooyoung on 10/31/24.
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import SwiftUI
import DesignSystem

struct DailyMemoAddView: View {
  @State private var memo: String = ""
  @State private var memoStringCount: Int = 0
  
  
  
  var body: some View {
    VStack(spacing: 0) {
      ZStack {
        HStack(spacing: 0) {
          Button {
            
          } label: {
            Text("닫기")
              .font(.pretendardMedium_18)
              .foregroundStyle(Color.main)
          }
          Spacer()
        }
        .padding(.horizontal, 16)

        Text("메모 추가")
          .font(.pretendardSemibold_18)
          .foregroundStyle(Color.textBlack)
      }
      
      ZStack(alignment: .topTrailing) {
        Text("(\(memoStringCount)/20)")
          .font(.pretendardMedium_12)
          .foregroundStyle(Color.textBlack)
          .frame(maxWidth: .infinity, alignment: .trailing)
          .padding(.horizontal, 16)
        FloatingTitleTextField(title: "메모", text: $memo, shouldShowKeyboard: true)
      }
      .padding(.top, 38)
      
      Spacer()
      
      Button {

      } label: {
        Text("저장하기")
          .font(.pretendardMedium_18)
          .padding(.vertical, 20)
          .frame(maxWidth: .infinity)
          .foregroundStyle(Color.whiteDefault)
          .background(Color.main)
      }
    }
    .frame(maxHeight: .infinity, alignment: .top)
    .padding(.top, 20)
  }
}

#Preview {
  DailyMemoAddView()
}

