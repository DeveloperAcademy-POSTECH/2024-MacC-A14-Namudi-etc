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
  
  private let resetAction: () -> Void
  
  init(
    numberText: Binding<String>,
    resetAction: @escaping () -> Void
  ) {
    self._numberText = numberText
    self.resetAction = resetAction
  }
  
  var body: some View {
    
    HStack(alignment: .center, spacing: 6) {
      
      HStack(alignment: .lastTextBaseline, spacing: 0) {
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
        self.resetAction()
      } label: {
//        Image(systemName: "arrow.trianglehead.counterclockwise")
        Image.reset
          .resizable()
          .frame(width: 40, height: 40)
      }
    }
    .frame(maxWidth: .infinity, alignment: .trailing)
    .foregroundStyle(Color.main)
  }
}

#Preview {
  AmountResultText(numberText: .constant("999999999999999")) {
    
  }
}
