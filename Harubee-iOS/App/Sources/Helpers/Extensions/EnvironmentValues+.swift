//
//  EnvironmentValues+.swift
//  Harubee-iOS
//
//  Created by 이정동 on 11/3/24.
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import SwiftUI

extension EnvironmentValues {
  var buttonAction: () -> Void {
    get { self[ButtonActionKey.self] }
    set { self[ButtonActionKey.self] = newValue }
  }
}
