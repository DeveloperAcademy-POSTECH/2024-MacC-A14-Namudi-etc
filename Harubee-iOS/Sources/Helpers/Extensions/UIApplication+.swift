//
//  UIApplication+.swift
//  Harubee-iOS
//
//  Created by 이정동 on 11/13/24.
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import UIKit

extension UIApplication {
  func endEditing() {
    sendAction(
      #selector(UIResponder.resignFirstResponder),
      to: nil,
      from: nil,
      for: nil
    )
  }
}
