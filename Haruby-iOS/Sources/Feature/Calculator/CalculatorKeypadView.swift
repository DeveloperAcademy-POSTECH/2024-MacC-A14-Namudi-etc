//
//  CalculationKeypad.swift
//  Haruby-iOS
//
//  Created by 이정동 on 10/13/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class CalculatorKeypadView: UIView {
    
    // MARK: - Properties
    
    private let disposeBag = DisposeBag()

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
    
    lazy var containerStackView: UIStackView = {
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
                bindButtonTouchDownUpEvent(button, type: buttonType)
            }
            
            containerStackView.addArrangedSubview(stackView)
        }
        
        keypadButtons.forEach {
                $0.layer.cornerRadius = self.buttonWidthSize / 2
                $0.clipsToBounds = true
            }
    }
}

extension CalculatorKeypadView {
    private func createStackView(isLastRow: Bool) -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = isLastRow ? .fill : .fillEqually
        stackView.alignment = .fill
        stackView.spacing = verticalSpacing
        return stackView
    }
    
    private func createButton(_ type: KeypadButtonType) -> UIButton {
        let button = UIButton(type: .custom)
        
        if type.style == .text {
            button.setTitle(type.title, for: .normal)
            button.setTitleColor(type.foregroundColor, for: .normal)
            button.titleLabel?.font = type.font
        } else {
            button.setImage(type.image, for: .normal)
            button.setImage(type.image, for: .highlighted)
            button.imageView?.tintColor = type.foregroundColor
            button.imageView?.contentMode = .scaleAspectFit
        }
        
        button.tag = type.rawValue
        button.backgroundColor = type.backgroundColor
        
        if type.isSquare {
            button.snp.makeConstraints { make in
                make.width.height.equalTo(self.buttonWidthSize)
            }
        }
        
        return button
    }
    
    private func bindButtonTouchDownUpEvent(_ button: UIButton, type: KeypadButtonType) {
        
        button.rx.controlEvent([.touchDown, .touchDragInside])
            .subscribe { _ in
                UIView.animate(withDuration: 0.1) {
                    button.backgroundColor = type.touchDownBackgroundColor
                }
                
            }
            .disposed(by: disposeBag)
        
        button.rx.controlEvent([.touchUpInside, .touchUpOutside, .touchDragOutside])
            .subscribe { _ in
                UIView.animate(withDuration: 0.1) {
                    button.backgroundColor = type.backgroundColor
                }
            }
            .disposed(by: disposeBag)
    }
}

