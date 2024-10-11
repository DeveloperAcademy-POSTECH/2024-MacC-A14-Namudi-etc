//
//  FixedIncomeManagementViewController.swift
//  Haruby-iOS
//
//  Created by namdghyun on 10/11/24.
//

import UIKit
import ReactorKit
import RxCocoa
import RxSwift
import SnapKit

class FixedIncomeManagementViewController: UIViewController, View {
    typealias Reactor = FixedIncomeManagementReactor
    
    var disposeBag = DisposeBag()
    
    // MARK: UI Components
    private let label: UILabel = {
        let label = UILabel()
        label.text = "고정 수입 관리"
        return label
    }()
    
    private let addButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("추가", for: .normal)
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
        title = "고정 수입 관리"
        
        [label, addButton].forEach { view.addSubview($0) }
        
        label.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
        }
        
        addButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.top.equalTo(label.snp.bottom).offset(20)
            make.height.equalTo(44)
        }
    }
    
    // MARK: Binding
    func bind(reactor: FixedIncomeManagementReactor) {
        // Action
        addButton.rx.tap
            .map { Reactor.Action.addIncome }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
}
