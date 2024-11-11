//
//  HelpButton.swift
//  Harubee-iOS
//
//  Created by namdghyun on 11/10/24.
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import SwiftUI

// MARK: - Help Button
struct HelpButton: View {
  @Binding var infoBubbleVisible: Bool
  
  var body: some View {
    Image(systemName: "questionmark.circle")
      .foregroundStyle(Color.whiteDefault)
      .tapFeedback {
        infoBubbleVisible.toggle()
      }
  }
}
