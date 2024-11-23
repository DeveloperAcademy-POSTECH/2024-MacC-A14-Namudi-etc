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
    
    var font: Font {
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
  
  let text: String
  let contentSize: ContentSize
  
  var body: some View {
    HStack {
      Image(.harubeeMain)
        .resizable()
        .frame(
          width: contentSize.imageSize,
          height: contentSize.imageSize
        )
      
      Text(text)
        .font(contentSize.font)
        .foregroundStyle(.main)
    }
  }
}
