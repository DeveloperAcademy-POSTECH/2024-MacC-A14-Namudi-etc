//
//  HarubeeWidgetBundle.swift
//  HarubeeWidget
//
//  Created by 이정동 on 11/20/24.
//

import WidgetKit
import SwiftUI

@main
struct HarubeeWidgetBundle: WidgetBundle {
    var body: some Widget {
        HarubeeWidget()
    }
}


/*
 Harubee App Target 파일들 중 Widget Target을 추가한 파일 리스트
 
 Resources
  - Colors
  - Images
  > Fonts
    - semiBold
    - medium
 Sources
  > Helper
    > DesignSystem
      - Color+
      - Font+
    > Extensions
      - Int+
 */
