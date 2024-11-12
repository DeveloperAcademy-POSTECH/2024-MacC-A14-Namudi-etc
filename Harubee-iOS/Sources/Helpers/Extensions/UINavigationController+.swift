//
//  NavigationBar+.swift
//  Harubee-iOS
//
//  Created by namdghyun on 11/7/24.
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import SwiftUI


extension UINavigationController: @retroactive ObservableObject, @retroactive UIGestureRecognizerDelegate {
  override open func viewDidLoad() {
    super.viewDidLoad()
    interactivePopGestureRecognizer?.delegate = self
  }
  
  public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
    return viewControllers.count > 1
  }
}


