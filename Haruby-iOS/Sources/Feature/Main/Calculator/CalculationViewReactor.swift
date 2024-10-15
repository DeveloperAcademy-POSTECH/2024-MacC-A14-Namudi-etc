//
//  CalculationViewReactor.swift
//  Haruby-iOS
//
//  Created by 이정동 on 10/14/24.
//

import Foundation
import ReactorKit
import RxSwift

final class CalculationViewReactor: Reactor {
    enum Action {
        case viewDidLoad
        case keypadButtonTapped(String)
    }
    
    enum Mutation {
        case initializeData
        case updateAverageHaruby(Int) // 평균 하루비, 지출 예정 금액, 입력 필드 업데이트
        case updateEstimatedPrice(Int)
        case updateInputField(String)
    }
    
    struct State {
        var isResultButtonClicked: Bool = false
        var averageHaruby: Int = 0
        var remainTotalHaruby: Int = 0
        var estimatedPrice: Int = 0
        var remainingDays: Int = 0
        var inputFieldText: String = ""
    }
    
    var initialState: State = State()
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            return .just(.initializeData)
        case .keypadButtonTapped(let text):
            return processKeypad(text)
            
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .initializeData:
            break
        case .updateAverageHaruby(let haruby):
            newState.averageHaruby = haruby
            newState.isResultButtonClicked = true
        case .updateEstimatedPrice(let price):
            newState.estimatedPrice = price
        case .updateInputField(let text):
            newState.inputFieldText = text
        }
        return newState
    }
}

extension CalculationViewReactor {
    
    private func processKeypad(_ text: String) -> Observable<Mutation> {
        
        if ["÷", "×", "+", "−"].contains(text) {
            return processOperator(text)
        } else if text == "=" {
            // 1. 계산
            // 2. 평균 하루비, 지출 예정 금액, 텍스트필드 업데이트
            return processEqual()
        } else if ["AC", ""].contains(text) {
            return processDelete(text)
        } else {
            // if text == "0"이고 필드의 마지막 텍스트가 "0"이면 return .empty()
            // else udpateInputTextField
            return processNumber(text)
        }
    }
    
    private func processOperator(_ op: String) -> Observable<Mutation> {
        let currentInputFieldText = self.currentState.inputFieldText
        let lastText = currentInputFieldText.last
        
        if ["+", "−", "×", "÷"].contains(lastText)
            || currentInputFieldText.isEmpty {
            return .empty()
        } else {
            return updateInputTextField(currentInputFieldText + op)
        }
    }
    
    private func processEqual() -> Observable<Mutation> {
        let result = evaluateExpression(self.currentState.inputFieldText)
        print(result)
        
        return .concat([
            updateHaruby(),
            updateEstimatedPrice(),
            updateInputTextField("")
        ])
    }
    
    private func processDelete(_ text: String) -> Observable<Mutation> {
        var newText = ""
        
        if text.isEmpty {
            newText = String(currentState.inputFieldText.dropLast())
        }
        
        return updateInputTextField(newText)
    }
    
    private func processNumber(_ number: String) -> Observable<Mutation> {
        let currentInputFieldText = self.currentState.inputFieldText
        let lastText = currentInputFieldText.last
        
        if ["0", "00", "000"].contains(number)
            && (["0", "+", "-", "×", "÷"].contains(lastText)
                || currentInputFieldText.isEmpty) {
            return .empty()
        } else {
            return updateInputTextField(currentInputFieldText + number)
        }
    }
    
    
    private func updateHaruby() -> Observable<Mutation> {
        .just(.updateAverageHaruby(100))
    }
    
    private func updateEstimatedPrice() -> Observable<Mutation> {
        .just(.updateEstimatedPrice(100))
    }
    
    private func updateInputTextField(_ text: String) -> Observable<Mutation> {
        return .just(.updateInputField(text))
    }
}

extension CalculationViewReactor {
    // 함수: 문자열 수식을 계산
    private func evaluateExpression(_ expression: String) -> Double? {
        var newExpression = expression
        if ["+", "-", "×", "÷"].contains(expression.last) {
            newExpression = String(newExpression.dropLast())
        }
        
        // 연산자 우선순위를 정의
        let operators: [Character: Int] = [
            "+": 1,
            "-": 1,
            "×": 2,
            "÷": 2
        ]
        
        // 후위 표기법으로 변환
        var values: [Double] = []
        var ops: [Character] = []
        
        var index = newExpression.startIndex
        while index < newExpression.endIndex {
            let char = newExpression[index]
            
            if char.isNumber || char == "." {
                // 숫자일 경우 숫자를 추출
                var numStr = ""
                while index < expression.endIndex && (newExpression[index].isNumber || newExpression[index] == ".") {
                    numStr.append(newExpression[index])
                    index = newExpression.index(after: index)
                }
                if let value = Double(numStr) {
                    values.append(value)
                }
                continue
            }
            
            if operators.keys.contains(char) {
                // 연산자일 경우 처리
                while let lastOp = ops.last, let lastOpPriority = operators[lastOp], let currentPriority = operators[char], lastOpPriority >= currentPriority {
                    ops.removeLast()
                    if let right = values.popLast(), let left = values.popLast() {
                        values.append(applyOperation(left, right, lastOp))
                    }
                }
                ops.append(char)
            }
            
            index = newExpression.index(after: index)
        }
        
        // 남은 연산자 처리
        while let op = ops.popLast() {
            if let right = values.popLast(), let left = values.popLast() {
                values.append(applyOperation(left, right, op))
            }
        }
        
        return values.last
    }

    // 연산을 적용하는 함수
    private func applyOperation(_ left: Double, _ right: Double, _ op: Character) -> Double {
        switch op {
        case "+":
            return left + right
        case "-":
            return left - right
        case "×":
            return left * right
        case "÷":
            return left / right
        default:
            fatalError("Unknown operator \(op)")
        }
    }
}
