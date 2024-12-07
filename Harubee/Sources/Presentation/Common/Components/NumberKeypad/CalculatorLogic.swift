//
//  CalculatorLogic.swift
//  Harubee-iOS
//
//  Created by 이정동 on 11/3/24.
//  Copyright © 2024 namudiEtc. All rights reserved.
//

import Foundation

struct CalculatorLogic {
  
  private let maxNumber = 99_999_999
  
  // MARK: - func processKeypad
  func processKeypad(
    _ keypadType: KeypadButtonType,
    expression: String
  ) -> (String, String) {
    var newExpression = expression
    
    switch keypadType {
    case .delete, .clear:
      newExpression = processDeleteType(
        keypadType,
        expression: expression
      )
    case .plus, .minus:
      newExpression = processOperatorType(
        keypadType,
        expression: expression
      )
    default:
      newExpression = processNumberType(
        keypadType,
        expression: expression
      )
    }
    
    let newAmount = processExpression(expression: newExpression)
    
    return (newExpression, newAmount)
  }
  
  // MARK: - func processNumberType
  private func processNumberType(
    _ keypadType: KeypadButtonType,
    expression: String
  ) -> String {
    
    let operators = KeypadButtonType.operators.map { $0.title }
    let zeros = KeypadButtonType.zeros.map { $0.title }
    
    var newExpression = expression
    let lastText = String(newExpression.last ?? Character(" "))
    
    // Case 1. 0이 눌린 경우
    if zeros.contains(keypadType.title) {
      
      // 현재 표현식이 0이 아니고, 마지막 텍스트가 연산자가 아닐 경우에 0 추가
      if !(newExpression == KeypadButtonType.zero.title
           || operators.contains(lastText)) {
        newExpression += keypadType.title
      }
      
      // Case 2. 숫자가 눌린 경우
    } else {
      
      // 현재 표현식이 0인 경우 입력된 키패드 숫자로 표시
      if newExpression == KeypadButtonType.zero.title {
        newExpression = keypadType.title
      }
      // 아닌 경우 기존 표현식에서 추가
      else { newExpression += keypadType.title }
    }
    
    // 현재 표현식에 decimal 적용
    newExpression = formatDecimalFromExpression(newExpression)
    
    return newExpression
  }
  
  // MARK: - processOperatorType
  private func processOperatorType(
    _ keypadType: KeypadButtonType,
    expression: String
  ) -> String {
    
    // 기존 표현식이 빈 문자열이면 리턴
    if expression.isEmpty { return "" }
    
    // 표현식의 마지막 텍스트
    let lastText = expression[expression.count - 1]
    
    // 표현식의 마지막 텍스트가 연산자인 경우 기존 표현식 리턴
    let operators = KeypadButtonType.operators.map { $0.title }
    if operators.contains(lastText) {
      return expression
    }
    
    // 기존 표현식에 입력된 키패드 추가
    return expression + keypadType.title
  }
  
  // MARK: - processDeleteType
  private func processDeleteType(
    _ keypadType: KeypadButtonType,
    expression: String
  ) -> String {
    
    // 기존 표현식이 빈 문자열인 경우 리턴
    if expression.isEmpty { return "" }
    
    if keypadType == .clear { return KeypadButtonType.zero.title }
    
    // 표현식의 마지막 텍스트를 제거
    var newExpression = expression
    let _ = newExpression.popLast()
    
    // 마지막 텍스트를 제거한 후에 표현식이 빈 문자열인 경우 "0"으로 리턴
    if newExpression.isEmpty {
      newExpression = KeypadButtonType.zero.title
    }
    
    // 현재 표현식에 decimal 적용
    newExpression = formatDecimalFromExpression(newExpression)
    
    return newExpression
  }
  
  // MARK: - processDoneType
  private func processExpression(
    expression: String
  ) -> String {
    
    // 표현식이 비어있으면 0으로 리턴
    if expression.isEmpty { return "" }
    
    var before = 0 // 피연산자 1
    var current = "" // 피연산자 2
    var op = KeypadButtonType.plus.title // 현재 연산자 (초기값 +)
    var index = 0 // 표현식 순차 탐색을 위한 index
    
    let operators = KeypadButtonType.operators.map { $0.title }
    
    // 표현식의 첫 문자가 -연산자인 경우
    if expression[index] == KeypadButtonType.minus.title {
      op = KeypadButtonType.minus.title
      index += 1
    }
    
    // 표현식을 앞에서부터 순차 탐색
    while index < expression.count {
      let char = expression[index]
      
      // 현재 문자가 연산자인 경우
      if operators.contains(char) {
        before = calculate(
          before: before,
          current: current.numberFormat!,
          op: op
        )
        current = ""
        op = char
        
        // 현재 문자가 숫자 또는 ,인 경우
      } else { current.append(char) }
      
      index += 1
    }
    
    if !current.isEmpty {
      before = calculate(
        before: before,
        current: current.numberFormat!,
        op: op
      )
    }
    
    if before >= maxNumber {
      return maxNumber.decimalWithWon
    } else if before <= -maxNumber {
      return (-maxNumber).decimalWithWon
    } else {
      return before.decimalWithWon
    }
  }
  
  // MARK: - processExpression
  private func calculate(
    before: Int,
    current: Int,
    op: String
  ) -> Int {
    switch op {
      
    case KeypadButtonType.plus.title:
      let result = before.addingReportingOverflow(current)
      if result.overflow { return before }
      else { return result.partialValue }
      
    case KeypadButtonType.minus.title:
      let result = before.subtractingReportingOverflow(current)
      if result.overflow { return before }
      else { return result.partialValue }
      
    default: return 0
    }
  }
  
  private func formatDecimalFromExpression(
    _ expression: String
  ) -> String {
    
    let operators = KeypadButtonType.operators.map { $0.title }
    
    var newExpression = expression
    
    // 표현식이 현재 비어있으면 빈 문자열 리턴
    if newExpression.isEmpty { return "" }
    
    // 표현식의 마지막 텍스트가 연산자면 기존값 리턴
    let lastText = newExpression[newExpression.count - 1]
    if operators.contains(lastText) { return newExpression }
    
    var currentIndex = newExpression.count - 1
    
    // 마지막 문자부터 거꾸로 탐색
    while (currentIndex > 0) {
      
      // 현재 문자가 연산자인 경우 index를 1 증가시키고 반복문 탈출
      if operators.contains(newExpression[currentIndex]) {
        currentIndex += 1
        break
      }
      currentIndex -= 1
    }
    
    var numberString = newExpression[(currentIndex)...] // 포멧할 숫자(decimal) 문자열
    
    var number: Int? = numberString.numberFormat
    while number == nil {
      let _ = numberString.popLast()
      number = numberString.numberFormat
    }
    newExpression[(currentIndex)...] = number!.decimal // 기존 표현식에서 마지막 숫자 문자열 부분을 교체
    
    return newExpression
  }
}
