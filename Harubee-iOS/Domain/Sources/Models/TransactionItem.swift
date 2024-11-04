//
//  TransactionItem.swift
//  Harubee-iOS
//
//
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import Foundation

public struct TransactionItem: Identifiable {
  public let id: String
  public var date: Date
  public var name: String
  public var price: Int
  
  public init(
    id: String = UUID().uuidString,
    date: Date,
    name: String,
    price: Int
  ) {
    self.id = id
    self.date = date
    self.name = name
    self.price = price
  }
  
  static var `default`: TransactionItem {
    .init(
      date: .init(),
      name: "",
      price: 0
    )
  }
}
