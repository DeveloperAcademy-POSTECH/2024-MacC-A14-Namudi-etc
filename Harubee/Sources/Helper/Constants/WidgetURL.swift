//
//  WidgetURL.swift
//  Harubee
//
//  Created by 이정동 on 11/24/24.
//

import Foundation

enum WidgetURL {
  case transactionInput
  
  var url: URL {
    switch self {
    case .transactionInput: URL(string: "harubee://transactionInput")!
    }
  }
}
