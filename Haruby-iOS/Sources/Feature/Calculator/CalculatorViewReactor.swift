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
        case keypadButtonTapped(KeypadButtonType)
    }
    
    enum Mutation {
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
    
    var initialState: State
    weak var coordinator: CalculatorCoordinator?
    
    /*
    init(coordinator: CalculatorCoordinator, salaryBudget: SalaryBudget) {
        let remainTotalHaruby = salaryBudget.balance
        let remainingDays = Int(salaryBudget.endDate.timeIntervalSince(.now.formattedDate) / 86400) + 1
        
        self.initialState = State(remainTotalHaruby: remainTotalHaruby, remainingDays: remainingDays)
        self.coordinator = coordinator
    }
     */
    init(coordinator: CalculatorCoordinator) {
        self.coordinator = coordinator
        self.initialState = .init()
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .keypadButtonTapped(let keypadType):
            return processKeypad(keypadType)
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
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

// MARK: - Mutate 함수
extension CalculatorViewReactor {
    
    private func processKeypad(_ keypadType: KeypadButtonType) -> Observable<Mutation> {
        
        switch keypadType {
        case .plus, .minus, .multiply, .divide:
            return processOperator(keypadType)
        case .equal:
            return processEqual()
        case .deleteAll, .deleteLast:
            return processDelete(keypadType)
        default:
            return processNumber(keypadType)
        }
    }
    
    private func processOperator(_ keypadType: KeypadButtonType) -> Observable<Mutation> {
        let currentInputFieldText = self.currentState.inputFieldText
        let lastText = currentInputFieldText.last?.description ?? ""
        
        let operatorTexts = KeypadButtonType.operators.map { $0.title }
        
        if operatorTexts.contains(lastText)
            || currentInputFieldText.isEmpty {
            return .empty()
        } else {
            let op = keypadType.title
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
    
    private func processDelete(_ keypadType: KeypadButtonType) -> Observable<Mutation> {
        switch keypadType {
        case .deleteAll:
            return .just(.updateInputField(""))
        case .deleteLast:
            let newText = String(currentState.inputFieldText.dropLast())
            return .just(.updateInputField(newText))
        default:
            return .empty()
        }
    }
    
    private func processNumber(_ keypadType: KeypadButtonType) -> Observable<Mutation> {
        let currentInputFieldText = self.currentState.inputFieldText
        let lastText = currentInputFieldText.last?.description ?? ""
        
        let zeroTypes = KeypadButtonType.zeros
        let operatorTexts = KeypadButtonType.operators.map { $0.title }
        
        if zeroTypes.contains(keypadType)
            && (operatorTexts.contains(lastText)
                || currentInputFieldText.isEmpty) {
            return .empty()
        } else {
            let number = keypadType.title
            return .just(.updateInputField(currentInputFieldText + number))
        }
    }
    
}


// MARK: - 계산기 로직
extension CalculatorViewReactor {
    // 함수: 문자열 수식을 계산
    private func evaluateExpression(_ expression: String) -> Int {
        var newExpression = expression
        let operatorTexts = KeypadButtonType.operators.map { $0.title }
        if operatorTexts.contains(expression.last?.description ?? "") {
            newExpression = String(newExpression.dropLast())
        }
        
        // 연산자 우선순위를 정의
        let operators: [Character: Int] = [
            CalculatorSymbol.plus.first!: 1,
            CalculatorSymbol.minus.first!: 1,
            CalculatorSymbol.multiply.first!: 2,
            CalculatorSymbol.divide.first!: 2
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
