//
//  AppSettingsViewController.swift
//  Haruby-iOS
//
//  Created by namdghyun on 10/11/24.
//

import UIKit
import ReactorKit
import RxCocoa
import SnapKit

class AppSettingsViewController: UIViewController, View {
    typealias Reactor = AppSettingsReactor
    
    var disposeBag = DisposeBag()
    
    // MARK: UI Components
    private let notificationSwitch: UISwitch = {
        let switchControl = UISwitch()
        return switchControl
    }()
    
    private let notificationLabel: UILabel = {
        let label = UILabel()
        label.text = "알림 설정"
        return label
    }()
    
    private let themeSegmentedControl: UISegmentedControl = {
        let items = ["Light", "Dark", "System"]
        let control = UISegmentedControl(items: items)
        return control
    }()
    
    private let themeLabel: UILabel = {
        let label = UILabel()
        label.text = "테마 설정"
        return label
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
        
        [notificationLabel, notificationSwitch, themeLabel, themeSegmentedControl].forEach { view.addSubview($0) }
        
        notificationLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.left.equalToSuperview().offset(20)
        }
        
        notificationSwitch.snp.makeConstraints { make in
            make.centerY.equalTo(notificationLabel)
            make.right.equalToSuperview().offset(-20)
        }
        
        themeLabel.snp.makeConstraints { make in
            make.top.equalTo(notificationLabel.snp.bottom).offset(40)
            make.left.equalToSuperview().offset(20)
        }
        
        themeSegmentedControl.snp.makeConstraints { make in
            make.top.equalTo(themeLabel.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(20)
        }
    }
    
    // MARK: Binding
    func bind(reactor: AppSettingsReactor) {
        // Action
        notificationSwitch.rx.isOn
            .map { Reactor.Action.setNotification($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        themeSegmentedControl.rx.selectedSegmentIndex
            .map { Reactor.Action.setTheme(AppSettingsReactor.Theme(rawValue: $0) ?? .system) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // State
        reactor.state.map { $0.isNotificationOn }
            .bind(to: notificationSwitch.rx.isOn)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.theme.rawValue }
            .bind(to: themeSegmentedControl.rx.selectedSegmentIndex)
            .disposed(by: disposeBag)
    }
}
