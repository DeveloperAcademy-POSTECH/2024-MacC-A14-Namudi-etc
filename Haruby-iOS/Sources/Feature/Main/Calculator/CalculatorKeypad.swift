//
//  CalculationKeypad.swift
//  Haruby-iOS
//
//  Created by 이정동 on 10/13/24.
//

import UIKit
import SnapKit

final class CalculatorKeypad: UIView {
    
    // MARK: - Properties

    private let horizontalSpacing: CGFloat = 27
    private let verticalSpacing: CGFloat = 18
    private let horizontalPadding: CGFloat = 40
    private let verticalPadding: CGFloat = 16
    private var buttonWidthSize: CGFloat {
        (UIScreen.main.bounds.width - (horizontalPadding * 2) - (horizontalSpacing * 3)) / 4
    }
    
    private let keypadTypes: [[KeypadButtonType]] = [
        [.deleteAll, .one, .four, .seven, .zero],
        [.divide, .two, .five, .eight, .doubleZero],
        [.multiply, .three, .six, .nine, .tripleZero],
        [.deleteLast, .minus, .plus, .equal]
    ]
    
    var keypadButtons: [UIButton] = []
    
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
                keypadButtons.append(button)
                stackView.addArrangedSubview(button)
            }
            
            containerStackView.addArrangedSubview(stackView)
        }
        
        keypadButtons.forEach {
                $0.layer.cornerRadius = self.buttonWidthSize / 2
                $0.clipsToBounds = true
            }
    }
}

extension CalculatorKeypad {
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
        
        button.tag = type.rawValue
        
        if type.style == .text {
            button.setTitle(type.title, for: .normal)
            button.setTitleColor(type.foregroundColor, for: .normal)
            button.titleLabel?.font = type.font
        } else {
            button.setImage(type.image, for: .normal)
            button.imageView?.tintColor = type.foregroundColor
            button.imageView?.contentMode = .scaleAspectFit
        }
        
        button.backgroundColor = type.backgroundColor
        
        if type.isSquare {
            button.snp.makeConstraints { make in
                make.width.height.equalTo(self.buttonWidthSize)
            }
        }
        
        return button
    }
}

enum KeypadButtonType: Int {
    enum Style {
        case text
        case image
    }
    
    // rawValue 0 ~ 11
    case zero, one, two, three, four, five, six, seven, eight, nine, doubleZero, tripleZero
    // rawValue 12 ~ 13
    case deleteAll, deleteLast
    // rawValue 14 ~ 18
    case plus, minus, multiply, divide, equal
    
    static let operators: [KeypadButtonType] = [.plus, .minus, .multiply, .divide]
    static let zeros: [KeypadButtonType] = [.zero, .doubleZero, .tripleZero]
    
    var style: Self.Style {
        switch self.rawValue {
        case 0...12: .text
        default: .image
        }
    }
    
    var title: String {
        switch self {
        case .one, .two, .three, .four, .five, .six, .seven, .eight, .nine, .zero:
            return String(self.rawValue)
        case .doubleZero: // 00
            return CalculatorSymbol.doubleZero
        case .tripleZero: // 000
            return CalculatorSymbol.tripleZero
        case .deleteAll:
            return CalculatorSymbol.deleteAll
            
        case .plus:
            return CalculatorSymbol.plus
        case .minus:
            return CalculatorSymbol.minus
        case .multiply:
            return CalculatorSymbol.multiply
        case .divide:
            return CalculatorSymbol.divide
        case .equal:
            return CalculatorSymbol.equal
        case .deleteLast:
            return CalculatorSymbol.deleteLast
        }
    }
    
    var image: UIImage? {
        switch self {
        case .plus:
            return UIImage(systemName: "plus")
        case .minus:
            return UIImage(systemName: "minus")
        case .multiply:
            return UIImage(systemName: "multiply")
        case .divide:
            return UIImage(systemName: "divide")
        case .equal:
            return UIImage(systemName: "equal")
        case .deleteLast:
            return UIImage(systemName: "delete.left.fill")
        default:
            return nil
        }
    }
    
    var foregroundColor: UIColor {
        switch self {
        case .one, .two, .three, .four, .five, .six, .seven, .eight, .nine, .zero, .doubleZero, .tripleZero:
            return .Haruby.textBlack
        case .equal:
            return .Haruby.white
        case .plus, .minus, .multiply, .divide, .deleteAll, .deleteLast:
            return .Haruby.main
        }
    }
    
    var backgroundColor: UIColor {
        switch self {
        case .one, .two, .three, .four, .five, .six, .seven, .eight, .nine, .zero, .doubleZero, .tripleZero:
            return .Haruby.white
        case .equal:
            return .Haruby.main
        case .plus, .minus, .multiply, .divide, .deleteAll, .deleteLast:
            return .Haruby.mainBright15
        }
    }
    
    var font: UIFont {
        return .pretendardRegular_24
    }
    
    var isSquare: Bool {
        if case .equal = self { return false }
        else { return true }
    }
}

