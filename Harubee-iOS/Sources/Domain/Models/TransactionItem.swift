//
//  TransactionItem.swift
//  Harubee-iOS
//
//
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import Foundation

struct TransactionItem: Identifiable, Equatable {
  let id: String
  var date: Date
  var name: String
  var price: Int
  
  init(
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
