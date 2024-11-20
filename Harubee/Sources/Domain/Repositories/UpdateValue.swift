//
//  UpdateValue.swift
//  Domain
//
//  Created by 이정동 on 10/30/24.
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import Foundation

enum UpdateValue<T> {
  case set(T)
  case keep
}
