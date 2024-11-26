//
//  KeyboardObserverManager.swift
//  Harubee-iOS
//
//  Created by 이정동 on 11/13/24.
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import SwiftUI

@Observable
final class KeyboardObserverManager {
  var isKeyboardVisible: Bool = false
  
  init() {
    // 키보드가 나타나는 경우
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(keyboardWillShow),
      name: UIResponder.keyboardWillShowNotification,
      object: nil
    )
    
    // 키보드가 사라지는 경우
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(keyboardWillHide),
      name: UIResponder.keyboardWillHideNotification,
      object: nil
    )
  }
  
  func hideKeyboard() {
    UIApplication.shared.endEditing()
  }
  
  @objc private func keyboardWillShow() {
    isKeyboardVisible = true
  }
  
  @objc private func keyboardWillHide() {
    isKeyboardVisible = false
  }
  
  deinit {
    NotificationCenter.default.removeObserver(self)
  }
}
