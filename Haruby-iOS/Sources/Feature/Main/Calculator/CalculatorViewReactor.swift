//
//  CalculationViewReactor.swift
//  Haruby-iOS
//
//  Created by 이정동 on 10/14/24.
//

import Foundation
import ReactorKit
import RxSwift

final class CalculatorViewReactor: Reactor {
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
        var remainTotalHaruby: Int = 170000
        var estimatedPrice: Int = 0
        var remainingDays: Int = 15
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

extension CalculatorViewReactor {
    
    private func processKeypad(_ text: String) -> Observable<Mutation> {
        
        if CalculatorSymbol.operators.contains(text) { // +, -, ×, ÷
            return processOperator(text)
        } else if text == CalculatorSymbol.equal { // =
            return processEqual()
        } else if CalculatorSymbol.deletes.contains(text) { // "AC", "Delete"
            return processDelete(text)
        } else { // Numbers
            return processNumber(text)
        }
    }
    
    private func processOperator(_ op: String) -> Observable<Mutation> {
        let currentInputFieldText = self.currentState.inputFieldText
        let lastText = currentInputFieldText.last?.description ?? ""
        
        if CalculatorSymbol.operators.contains(lastText)
            || currentInputFieldText.isEmpty {
            return .empty()
        } else {
            return .just(.updateInputField(currentInputFieldText + op))
        }
    }
    
    private func processEqual() -> Observable<Mutation> {
        let currentText = self.currentState.inputFieldText
        let result = evaluateExpression(currentText)
        let remainTotalHaruby = self.currentState.remainTotalHaruby
        let remainingDays = self.currentState.remainingDays
        
        let avgHaruby = (remainTotalHaruby - result) / remainingDays
        
        return .concat([
            .just(.updateAverageHaruby(avgHaruby)),
            .just(.updateEstimatedPrice(result)),
            .just(.updateInputField(""))
        ])
    }
    
    private func processDelete(_ text: String) -> Observable<Mutation> {
        var newText = ""
        
        if text.isEmpty {
            newText = String(currentState.inputFieldText.dropLast())
        }
        
        return .just(.updateInputField(newText))
    }
    
    private func processNumber(_ number: String) -> Observable<Mutation> {
        let currentInputFieldText = self.currentState.inputFieldText
        let lastText = currentInputFieldText.last?.description ?? ""
        
        if CalculatorSymbol.zeros.contains(number)
            && (CalculatorSymbol.operators.contains(lastText)
                
                || currentInputFieldText.isEmpty) {
            return .empty()
        } else {
            return .just(.updateInputField(currentInputFieldText + number))
        }
    }
    
}

extension CalculatorViewReactor {
    // 함수: 문자열 수식을 계산
    private func evaluateExpression(_ expression: String) -> Int {
        var newExpression = expression
        if CalculatorSymbol.operators.contains(expression.last?.description ?? "") {
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
        var values: [Int] = []
        var ops: [Character] = []
        
        var index = newExpression.startIndex
        while index < newExpression.endIndex {
            let char = newExpression[index]
            
            if char.isNumber {
                // 숫자일 경우 숫자를 추출
                var numStr = ""
                while index < newExpression.endIndex && (newExpression[index].isNumber) {
                    numStr.append(newExpression[index])
                    index = newExpression.index(after: index)
                }
                if let value = Int(numStr) {
                    values.append(value)
                }
                continue
            }
            
            if operators.keys.contains(char) {
                // 연산자일 경우 처리
                while let lastOp = ops.last,
                        let lastOpPriority = operators[lastOp],
                        let currentPriority = operators[char],
                        lastOpPriority >= currentPriority {
                    
                    ops.removeLast()
                    
                    if let right = values.popLast(),
                        let left = values.popLast() {
                        values.append(applyOperation(left, right, lastOp))
                    }
                }
                ops.append(char)
            }
            
            index = newExpression.index(after: index)
        }
        
        // 남은 연산자 처리
        while let op = ops.popLast() {
            if let right = values.popLast(),
                let left = values.popLast() {
                values.append(applyOperation(left, right, op))
            }
        }
        
        return values.last ?? 0
    }

    // 연산을 적용하는 함수
    private func applyOperation(_ left: Int, _ right: Int, _ op: Character) -> Int {
        switch String(op) {
        case CalculatorSymbol.plus:
            return left + right
        case CalculatorSymbol.minus:
            return left - right
        case CalculatorSymbol.multiply:
            return left * right
        case CalculatorSymbol.divide:
            return left / right
        default:
            fatalError("Unknown operator \(op)")
        }
    }
}
