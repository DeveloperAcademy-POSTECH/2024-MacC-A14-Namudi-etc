//
//  TransactionItem.swift
//  Harubee-iOS
//
//
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import Foundation

struct TransactionItem: Identifiable, Hashable {
  let id: String
  var date: Date
  var day: Int
  var name: String
  var price: Int
  
  init(
    id: String = UUID().uuidString,
    date: Date,
    day: Int = 1,
    name: String,
    price: Int
  ) {
    self.id = id
    self.date = date
    self.day = day
    self.name = name
    self.price = price
  }
  
  static var `default`: TransactionItem {
    .init(
      date: .init(),
      day: 1,
      name: "",
      price: 0
    )
  }
}
