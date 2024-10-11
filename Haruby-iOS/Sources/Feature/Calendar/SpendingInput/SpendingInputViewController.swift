//
//  SpendingInputViewController.swift
//  Haruby-iOS
//
//  Created by namdghyun on 10/11/24.
//

import UIKit
import ReactorKit
import RxCocoa
import SnapKit

class SpendingInputViewController: UIViewController, View {
    typealias Reactor = SpendingInputReactor
    
    var disposeBag = DisposeBag()
    
    // MARK: UI Components
    private let amountTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "지출 금액"
        textField.borderStyle = .roundedRect
        textField.keyboardType = .numberPad
        return textField
    }()
    
    private let categoryTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "카테고리"
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    private let saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("저장", for: .normal)
        return button
    }()
    
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
        
        [amountTextField, categoryTextField, saveButton].forEach { view.addSubview($0) }
        
        amountTextField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }
        
        categoryTextField.snp.makeConstraints { make in
            make.top.equalTo(amountTextField.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }
        
        saveButton.snp.makeConstraints { make in
            make.top.equalTo(categoryTextField.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.width.equalTo(100)
            make.height.equalTo(44)
        }
    }
    
    // MARK: Binding
    func bind(reactor: SpendingInputReactor) {
    }
}
