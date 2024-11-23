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
      Text("오늘의 하루비")
        .font(contentSize.titleFont)
        .foregroundStyle(.textBright)
      
      HStack(spacing: 5) {
        Image(.harubeeMain)
          .resizable()
          .frame(
            width: contentSize.imageSize,
            height: contentSize.imageSize
          )
        
        ViewThatFits {
          Text(harubee.decimalWithWon)
          Text(harubee.formattedAsTenThousandWon)
        }
        .lineLimit(1)
        .font(contentSize.harubeeFont)
        .foregroundStyle(.main)
      }
    }
  }
}
