//
//  TransactionItemDTO.swift
//  Harubee-iOS
//
//
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import Foundation
import SwiftData

@Model
public final class TransactionItemDTO {
  @Attribute(.unique) var identifier: String
  var date: Date
  var name: String
  var price: Int
  
  public init(
    id: String,
    date: Date,
    name: String,
    price: Int
  ) {
    self.identifier = id
    self.date = date
    self.name = name
    self.price = price
  }
  
  public convenience init(_ data: TransactionItem) {
    self.init(
      id: data.id,
      date: data.date,
      name: data.name,
      price: data.price
    )
  }
}

extension TransactionItemDTO {
  public func toEntity() -> TransactionItem {
    return TransactionItem(
      id: self.identifier,
      date: self.date,
      name: self.name,
      price: self.price
    )
  }
}
