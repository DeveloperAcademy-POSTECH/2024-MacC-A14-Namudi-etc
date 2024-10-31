//
//  Date+.swift
//  Harubee-iOS
//
//  Created by 신승재 on 10/30/24.
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import Foundation

extension Date {
  /// 년도 월 일 (요일) 표기
  var koreanFullDateString: String {
      let formatter = DateFormatter()
      formatter.dateFormat = "yyyy년 MM월 dd일 (E)"
      formatter.locale = Locale(identifier: "ko_KR")
      return formatter.string(from: self)
  }
}
