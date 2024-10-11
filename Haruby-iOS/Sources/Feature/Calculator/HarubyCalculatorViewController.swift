//
//  HarubyCalculatorViewController.swift
//  Haruby-iOS
//
//  Created by namdghyun on 10/11/24.
//

import UIKit
import ReactorKit
import RxCocoa
import SnapKit

class HarubyCalculatorViewController: UIViewController, View {
    typealias Reactor = HarubyCalculatorReactor
    
    // MARK: UI Components
    private let currentHarubyLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()
    
    private let expenseTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "지출 금액 입력"
        textField.borderStyle = .roundedRect
        textField.keyboardType = .numberPad
        return textField
    }()
    
    private let calculateButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("계산하기", for: .normal)
        return button
    }()
    
    private let resultLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    var disposeBag = DisposeBag()
    
    // MARK: Initializer
    init(reactor: Reactor) {
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: Setup
    private func setupUI() {
        view.backgroundColor = .white
        
        [currentHarubyLabel, expenseTextField, calculateButton, resultLabel].forEach {
            view.addSubview($0)
        }
        
        currentHarubyLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        expenseTextField.snp.makeConstraints { make in
            make.top.equalTo(currentHarubyLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }
        
        calculateButton.snp.makeConstraints { make in
            make.top.equalTo(expenseTextField.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.width.equalTo(100)
            make.height.equalTo(44)
        }
        
        resultLabel.snp.makeConstraints { make in
            make.top.equalTo(calculateButton.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
    }
    
    // MARK: Binding
    func bind(reactor: HarubyCalculatorReactor) {
        // Action
        expenseTextField.rx.text.orEmpty
            .map { Reactor.Action.updateExpense($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        calculateButton.rx.tap
            .map { Reactor.Action.calculate }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // State
        reactor.state.map { $0.currentHaruby }
            .distinctUntilChanged()
            .map { "현재 하루비: \($0)원" }
            .bind(to: currentHarubyLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.result }
            .distinctUntilChanged()
            .bind(to: resultLabel.rx.text)
            .disposed(by: disposeBag)
    }
}
