//
//  CalculationKeypad.swift
//  Haruby-iOS
//
//  Created by 이정동 on 10/13/24.
//

import UIKit
import SnapKit

final class CalculationKeypad: UIView {
    
    enum KeypadButtonType {
        case number(String)
        case operatorSymbol(String)
        case delete(String)
        
        var title: String {
            switch self {
            case .number(let value), .operatorSymbol(let value), .delete(let value):
                return value
            }
        }
        
        var textColor: UIColor {
            switch self {
            case .number:
                return .Haruby.textBlack
            case .operatorSymbol(let symbol):
                return symbol == CalculatorSymbol.equal ? .Haruby.white : .Haruby.main
            case .delete:
                return .Haruby.main
            }
        }
        
        var backgroundColor: UIColor {
            switch self {
            case .number:
                return .Haruby.white
            case .operatorSymbol(let symbol):
                return symbol == CalculatorSymbol.equal ? .Haruby.main : .Haruby.mainBright15
            case .delete:
                return .Haruby.mainBright15
            }
        }
        
        var font: UIFont {
            switch self {
            case .number, .delete:
                return .pretendardRegular_24
            case .operatorSymbol:
                return .pretendardExtraLight_37()
            }
        }
        
        var isSquare: Bool {
            if case let .operatorSymbol(type) = self,
               type == CalculatorSymbol.equal { return false }
            return true
        }
    }
    
    // MARK: - Properties

    private let horizontalSpacing: CGFloat = 27
    private let verticalSpacing: CGFloat = 18
    private let horizontalPadding: CGFloat = 40
    private let verticalPadding: CGFloat = 16
    private var buttonWidthSize: CGFloat {
        (UIScreen.main.bounds.width - (horizontalPadding * 2) - (horizontalSpacing * 3)) / 4
    }
    
    private let keypadTypes: [[KeypadButtonType]] = [
        [.delete(CalculatorSymbol.deleteAll), .number("1"), .number("4"), .number("7"), .number("0")],
        [.operatorSymbol(CalculatorSymbol.divide), .number("2"), .number("5"), .number("8"), .number("00")],
        [.operatorSymbol(CalculatorSymbol.multiply), .number("3"), .number("6"), .number("9"), .number("000")],
        [.delete(CalculatorSymbol.deleteLast), .operatorSymbol(CalculatorSymbol.minus), .operatorSymbol(CalculatorSymbol.plus), .operatorSymbol(CalculatorSymbol.equal)]
    ]
    
    var numberButtons: [UIButton] = []
    var operatorButtons: [UIButton] = []
    var deleteButtons: [UIButton] = []
    
    
    // MARK: - UI Components
    
    private lazy var containerStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.distribution = .fillEqually
        view.alignment = .fill
        view.spacing = horizontalSpacing
        return view
    }()
    
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup View
    private func setupView() {
        backgroundColor = .Haruby.whiteDeep
        
        setupSubviews()
        setupConstraints()
        setupKeypads()
    }
    
    private func setupSubviews() {
        addSubview(containerStackView)
    }
    
    private func setupConstraints() {
        containerStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(self.verticalPadding)
            make.bottom.equalTo(self.safeAreaLayoutGuide).inset(self.verticalPadding)
            make.horizontalEdges.equalToSuperview().inset(self.horizontalPadding)
        }
    }
    
    private func setupKeypads() {
        for (idx, keypad) in keypadTypes.enumerated() {
            
            let stackView = createStackView(isLastRow: idx == keypadTypes.count - 1)
            
            for buttonType in keypad {
                let button = createButton(buttonType)
                
                if case .number = buttonType {
                    numberButtons.append(button)
                } else if case .operatorSymbol = buttonType {
                    operatorButtons.append(button)
                } else if case .delete = buttonType {
                    deleteButtons.append(button)
                }
                stackView.addArrangedSubview(button)
            }
            
            containerStackView.addArrangedSubview(stackView)
        }
        
        [numberButtons, operatorButtons, deleteButtons].flatMap { $0 }
            .forEach {
                $0.layer.cornerRadius = self.buttonWidthSize / 2
                $0.clipsToBounds = true
            }
    }
}

extension CalculationKeypad {
    private func createStackView(isLastRow: Bool) -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = isLastRow ? .fill : .fillEqually
        stackView.alignment = .fill
        stackView.spacing = verticalSpacing
        return stackView
    }
    
    private func createButton(_ type: KeypadButtonType) -> UIButton {
        let button = UIButton()
        if type.title.isEmpty {
            button.setImage(.delete, for: .normal)
//            button.setImage(UIImage(systemName: "delete.left.fill").resi, for: .normal)
            button.imageView?.tintColor = type.textColor
            button.imageView?.contentMode = .scaleAspectFit
            button.imageView?.backgroundColor = type.backgroundColor
        } else {
            button.setTitle(type.title, for: .normal)
            button.setTitleColor(type.textColor, for: .normal)
            button.titleLabel?.font = type.font
            button.backgroundColor = type.backgroundColor
        }
        
        if type.isSquare {
            button.snp.makeConstraints { make in
                make.width.height.equalTo(self.buttonWidthSize)
            }
        }
        
        return button
    }
}

