//
//  CalculationKeypad.swift
//  Haruby-iOS
//
//  Created by 이정동 on 10/13/24.
//

import UIKit
import SnapKit

enum ButtonType {
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
            return symbol == "=" ? .Haruby.white : .Haruby.main
        case .delete:
            return .Haruby.main
        }
    }
    
    var backgroundColor: UIColor {
        switch self {
        case .number:
            return .clear
        case .operatorSymbol(let symbol):
            return symbol == "=" ? .Haruby.main : .Haruby.white
        case .delete:
            return .Haruby.white
        }
    }
    
    var font: UIFont {
        switch self {
        case .number, .delete:
            return .pretendardRegular_20()
        case .operatorSymbol(let symbol):
            return .pretendardRegular_24()
        }
    }
    
    var isSquare: Bool {
        if case let .operatorSymbol(type) = self,
           type == "=" {
            return false
        }
        return true
    }
}

final class CalculationKeypad: UIView {
    
    private lazy var containerStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.distribution = .fillEqually
        view.alignment = .fill
        view.spacing = spacing
        return view
    }()
    
    private let spacing: CGFloat = 26
    private let horizontalPadding: CGFloat = 38
    private let verticalPadding: CGFloat = 16
    private var buttonWidthSize: CGFloat {
        (UIScreen.main.bounds.width - (horizontalPadding * 2) - (spacing * 3)) / 4
    }
    
    private let keypadTypes: [[ButtonType]] = [
        [.delete("AC"), .number("1"), .number("4"), .number("7"), .number("0")],
        [.operatorSymbol("÷"), .number("2"), .number("5"), .number("8"), .number("00")],
        [.operatorSymbol("×"), .number("3"), .number("6"), .number("9"), .number("000")],
        [.delete(""), .operatorSymbol("−"), .operatorSymbol("+"), .operatorSymbol("=")]
    ]
    
    var numberButtons: [UIButton] = []
    var operatorButtons: [UIButton] = []
    var deleteButtons: [UIButton] = []

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .Haruby.whiteDeep
        
        addSubviews()
        configureConstraints()
        configureKeypads()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - addSubviews()
    
    private func addSubviews() {
        addSubview(containerStackView)
    }
    
    // MARK: - configureConstraints()
    
    private func configureConstraints() {
        containerStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(self.verticalPadding)
            make.bottom.equalTo(self.safeAreaLayoutGuide).inset(self.verticalPadding)
            make.horizontalEdges.equalToSuperview().inset(self.horizontalPadding)
        }
    }
    
    private func configureKeypads() {
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
        
        [operatorButtons, deleteButtons].flatMap { $0 }
            .forEach {
                $0.layer.cornerRadius = self.buttonWidthSize / 2
            }
    }
}

extension CalculationKeypad {
    private func createStackView(isLastRow: Bool) -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = isLastRow ? .fill : .fillEqually
        stackView.alignment = .fill
        stackView.spacing = spacing
        return stackView
    }
    
    private func createButton(_ type: ButtonType) -> UIButton {
        let button = UIButton()
        if type.title.isEmpty {
            button.setImage(.purpleHaruby, for: .normal)
            button.imageView?.tintColor = type.textColor
            button.imageView?.contentMode = .scaleAspectFit
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

