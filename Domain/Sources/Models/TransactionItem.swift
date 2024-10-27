//
//  TransactionItem.swift
//  Harubee-iOS
//
//
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import Foundation

public struct TransactionItem: Identifiable {
  public let id: UUID
  public var date: Date
  public let name: String
  public let price: Int
  
  static var `default`: TransactionItem {
    .init(
      id: .init(),
      date: .init(),
      name: "",
      price: 0
    )
  }
}
