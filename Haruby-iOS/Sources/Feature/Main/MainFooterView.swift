//
//  MainFooterView.swift
//  Haruby-iOS
//
//  Created by namdghyun on 10/15/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class MainFooterView: UIView {
    // MARK: - UI Components
    let navigateCalculatorButton = NavigationButton()
    let navigateCalendarButton = NavigationButton()
    let navigateManagementButton = NavigationButton()
    
    private lazy var navigateStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [navigateCalendarButton, navigateManagementButton])
        stackView.axis = .horizontal
        stackView.spacing = 9
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupInitialValues()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    private func setupView() {
        addSubview(navigateCalculatorButton)
        addSubview(navigateStackView)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        navigateCalculatorButton.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(106)
        }
        
        navigateStackView.snp.makeConstraints { make in
            make.top.equalTo(navigateCalculatorButton.snp.bottom).offset(11)
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(66)
        }
    }
    
    private func setupInitialValues() {
        navigateCalculatorButton.customTitleLabel.text = "하루비 계산기"
        navigateCalculatorButton.customSubTitleLabel.text = "지금 지출이 앞으로의 하루비에 얼마나 영향을 줄까요?"
        navigateCalculatorButton.symbolImageView.image = UIImage(systemName: "plus.forwardslash.minus")
        
        navigateCalendarButton.customTitleLabel.text = "하루비 달력"
        navigateCalendarButton.customSubTitleLabel.text = "하루비 확인 및 조정"
        navigateCalendarButton.symbolImageView.image = UIImage(systemName: "calendar")
        
        navigateManagementButton.customTitleLabel.text = "하루비 관리"
        navigateManagementButton.customSubTitleLabel.text = "고정지출 및 수입 관리"
        navigateManagementButton.symbolImageView.image = UIImage(systemName: "wonsign")
    }
}

// MARK: - Rx
extension Reactive where Base: MainFooterView {
    var tapCalculator: ControlEvent<Void> {
        return base.navigateCalculatorButton.rx.tap
    }
    
    var tapCalendar: ControlEvent<Void> {
        return base.navigateCalendarButton.rx.tap
    }
    
    var tapManagement: ControlEvent<Void> {
        return base.navigateManagementButton.rx.tap
    }
}
