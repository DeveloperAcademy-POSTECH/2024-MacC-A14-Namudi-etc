//
//  AmountResultText.swift
//  Harubee-iOS
//
//  Created by 이정동 on 10/31/24.
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import SwiftUI
import Shared

struct AmountResultText: View {
  @Binding private var numberText: String
  @Binding private var isUpdated: Bool
  
  init(numberText: Binding<String>, isUpdated: Binding<Bool>) {
    self._numberText = numberText
    self._isUpdated = isUpdated
  }
  
  var body: some View {
    
    HStack(spacing: 10) {
      
      HStack(alignment: .firstTextBaseline, spacing: 0) {
        ViewThatFits {
          Text(numberText.isEmpty ? "-" : numberText)
            .font(.pretendardSemibold_40)
          
          Text(numberText.isEmpty ? "-" : numberText)
            .font(.pretendardSemibold_30)
          
          Text(numberText.isEmpty ? "-" : numberText)
            .font(.pretendardSemibold_20)
            .lineLimit(3)
        }
        
        Text("원")
          .font(.pretendardSemibold_40)
      }
      
      Button {
        
      } label: {
        Image(systemName: "arrow.trianglehead.counterclockwise")
          .font(.system(size: 32, weight: .bold))
      }
    }
    .frame(maxWidth: .infinity, alignment: .trailing)
    .foregroundStyle(Color.main)
  }
}

#Preview {
  AmountResultText(numberText: .constant("1234567890"), isUpdated: .constant(true))
}
