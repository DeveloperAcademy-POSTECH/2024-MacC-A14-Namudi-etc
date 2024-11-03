//
//  CalculatorLogic.swift
//  Harubee-iOS
//
//  Created by 이정동 on 11/3/24.
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import Foundation

struct CalculatorLogic {
  // MARK: - func processKeypad
  func processKeypad(
    _ keypadType: KeypadButtonType,
    expression: String
  ) -> String {
    var newExpression = expression
    
    switch keypadType {
    case .delete:
      newExpression = processDeleteType(
        expression: expression
      )
    case .plus, .minus:
      newExpression = processOperatorType(
        keypadType,
        expression: expression
      )
    case .done:
      newExpression = processDoneType(
        expression: expression
      )
    default:
      newExpression = processNumberType(
        keypadType,
        expression: expression
      )
    }
    
    newExpression = formatDecimalFromExpression(newExpression)
    
    return newExpression
  }
  
  // MARK: - func processNumberType
  private func processNumberType(
    _ keypadType: KeypadButtonType,
    expression: String
  ) -> String {
    
    // 0이 눌렸을 때
    if KeypadButtonType.zeros.contains(keypadType) {
      // 0이 동작하지 않아야 하는 경우
      
      // - 텍스트가 비어있을 때
      if expression.isEmpty {
        return KeypadButtonType.zero.title
      }
      
      let lastText = String(expression.last!)
      
      // - 길이가 1이고 마지막 텍스트가 0일 때
      if expression.count == 1
          && lastText == KeypadButtonType.zero.title {
        return KeypadButtonType.zero.title
      }
      
      // - 마지막 텍스트가 연산자일 때
      if lastText == KeypadButtonType.plus.title
          || lastText == KeypadButtonType.minus.title {
        return expression
      }
    }
    
    if expression.count == 1 && String(expression.last!) == KeypadButtonType.zero.title {
      return keypadType.title
    }
    
    
    return expression + keypadType.title
  }
  
  // MARK: - processOperatorType
  private func processOperatorType(
    _ keypadType: KeypadButtonType,
    expression: String
  ) -> String {
    
    if expression.isEmpty { return expression }
    
    let lastText = String(expression.last!)
    
    if lastText == KeypadButtonType.plus.title
        || lastText == KeypadButtonType.minus.title {
      return expression
    }
    
    return expression + keypadType.title
  }
  
  // MARK: - processDeleteType
  private func processDeleteType(
    expression: String
  ) -> String {
    
    if expression.isEmpty { return expression }
    
    var newExpression = expression
    let _ = newExpression.popLast()
    
    if newExpression.isEmpty { newExpression = "0" }
    return newExpression
  }
  
  // MARK: - processDoneType
  private func processDoneType(
    expression: String
  ) -> String {
    
    if expression.isEmpty { return "0" }
    
    var before = 0
    var current = ""
    var op = "+"
    
    var index = 0
    
    if expression[index] == "-" {
      op = "-"
      index += 1
    }
    
    while index < expression.count {
      let curCharacter = expression[index]
      
      if curCharacter.isSingleNumber {
        current.append(curCharacter)
      } else if ["+", "-"].contains(curCharacter) {
        before = processExpression(
          before: before,
          current: Int(current)!,
          op: op
        )
        current = ""
        op = curCharacter
      }
      
      index += 1
    }
    
    if !current.isEmpty {
      before = processExpression(
        before: before,
        current: Int(current)!,
        op: op
      )
    }
    
    return before.decimal
  }
  
  // MARK: - processExpression
  private func processExpression(
    before: Int,
    current: Int,
    op: String
  ) -> Int {
    if op == "+" {
      return before + current
    } else {
      return before - current
    }
  }
  
  private func formatDecimalFromExpression(
    _ expression: String
  ) -> String {
    
    var newExpression = expression
    
    // 표현식이 현재 비어있으면 기존값 리턴
    if newExpression.isEmpty { return newExpression }
    
    // 표현식의 마지막 텍스트가 연산자면 기존값 리턴
    let lastText = newExpression[newExpression.count - 1]
    if ["+", "-"].contains(lastText) {
      return newExpression
    }
    
    var currentIndex = newExpression.count - 1
    
    // 현재 보고있는 문자가 연산자가 아니거나, 인덱스가 0이상인 동안
    while (currentIndex > 0) {
      if ["+", "-"].contains(newExpression[currentIndex]) {
        break
      }
      currentIndex -= 1
    }
    
    if ["+", "-"].contains(newExpression[currentIndex]) {
      currentIndex += 1
    }
    
    let text = newExpression[(currentIndex)...]
    let number = text.numberFormat!
    newExpression[(currentIndex)...] = number.decimal
    return newExpression
  }
}
