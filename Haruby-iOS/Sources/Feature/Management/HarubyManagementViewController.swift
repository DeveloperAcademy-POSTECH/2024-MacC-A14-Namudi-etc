//
//  HarubyManagementViewController.swift
//  Haruby-iOS
//
//  Created by namdghyun on 10/11/24.
//

import UIKit
import ReactorKit
import RxCocoa
import SnapKit

class HarubyManagementViewController: UIViewController, View {
    typealias Reactor = HarubyManagementReactor
    
    // MARK: UI Components
    private let appSettingsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("앱 설정", for: .normal)
        return button
    }()
    
    private let fixedIncomeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("고정 수입 관리", for: .normal)
        return button
    }()
    
    private let fixedExpenseButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("고정 지출 관리", for: .normal)
        return button
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
        
        [appSettingsButton, fixedIncomeButton, fixedExpenseButton].forEach {
            view.addSubview($0)
        }
        
        appSettingsButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }
        
        fixedIncomeButton.snp.makeConstraints { make in
            make.top.equalTo(appSettingsButton.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }
        
        fixedExpenseButton.snp.makeConstraints { make in
            make.top.equalTo(fixedIncomeButton.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }
    }
    
    // MARK: Binding
    func bind(reactor: HarubyManagementReactor) {
        // Action
        appSettingsButton.rx.tap
            .map { Reactor.Action.appSettingsButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        fixedIncomeButton.rx.tap
            .map { Reactor.Action.fixedIncomeButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        fixedExpenseButton.rx.tap
            .map { Reactor.Action.fixedExpenseButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
}
