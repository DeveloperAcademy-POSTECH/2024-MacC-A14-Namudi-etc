//
//  TransactionItemDTO.swift
//  Harubee-iOS
//
//
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import Foundation
import SwiftData


// MARK: - SchemaV2

typealias TransactionItemDTO = SchemaV2.TransactionItemDTO

extension SchemaV2 {
  @Model
  final class TransactionItemDTO {
    @Attribute(.unique) var identifier: String
    var date: Date
    var day: Int = 1
    var name: String
    var price: Int
    
    init(
      id: String,
      date: Date,
      day: Int = 1,
      name: String,
      price: Int
    ) {
      self.identifier = id
      self.date = date
      self.day = day
      self.name = name
      self.price = price
    }
    
    convenience init(_ data: TransactionItem) {
      self.init(
        id: data.id,
        date: data.date,
        day: data.day,
        name: data.name,
        price: data.price
      )
    }
  }
}

// MARK: - SchemaV1
extension SchemaV1 {
  
  @Model
  final class TransactionItemDTO {
    @Attribute(.unique) var identifier: String
    var date: Date
    var name: String
    var price: Int
    
    init(
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
    
    convenience init(_ data: TransactionItem) {
      self.init(
        id: data.id,
        date: data.date,
        name: data.name,
        price: data.price
      )
    }
  }
}


// MARK: - toEntity()
extension TransactionItemDTO {
  func toEntity() -> TransactionItem {
    return TransactionItem(
      id: self.identifier,
      date: self.date,
      day: self.day,
      name: self.name,
      price: self.price
    )
  }
}
