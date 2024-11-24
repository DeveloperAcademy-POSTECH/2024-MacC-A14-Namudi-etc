//
//  TodayHarubeeTextView.swift
//  HarubeeWidgetExtension
//
//  Created by 이정동 on 11/22/24.
//

import SwiftUI

// MARK: - TodayHarubeeTextView
struct TodayHarubeeTextView: View {
  
  enum ContentSize {
    case first
    case second
    
    var titleFont: Font {
      switch self {
      case .first: .pretendardMedium_14
      case .second: .pretendardMedium_12
      }
    }
    
    var harubeeFont: Font {
      switch self {
      case .first: .pretendardSemibold_20
      case .second: .pretendardSemibold_18
      }
    }
    
    var imageSize: CGFloat {
      switch self {
      case .first: 18
      case .second: 16
      }
    }
  }
  
  let title: String
  let harubee: Int
  let contentSize: ContentSize
  
  var body: some View {
    VStack(alignment: .leading, spacing: 2) {
      Text(title)
        .font(contentSize.titleFont)
        .foregroundStyle(.textBright)
      
      HStack(spacing: 0) {
        Image(.harubeeMain)
          .resizable()
          .frame(
            width: contentSize.imageSize,
            height: contentSize.imageSize
          )
        
        Group {
          AmountText(amount: harubee)
            .padding(.leading, 5)
          
          Text("원")
        }
        .font(contentSize.harubeeFont)
        .foregroundStyle(.main)
      }
    }
  }
}
