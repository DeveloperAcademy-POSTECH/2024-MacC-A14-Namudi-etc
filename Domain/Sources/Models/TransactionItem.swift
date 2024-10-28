//
//  TransactionItem.swift
//  Harubee-iOS
//
//
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import Foundation

public struct TransactionItem: Identifiable {
  public let id: String = UUID().uuidString
  public var date: Date
  public var name: String
  public var price: Int
  
  static var `default`: TransactionItem {
    .init(
      date: .init(),
      name: "",
      price: 0
    )
  }
}
