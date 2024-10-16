//
//  MainFooterView.swift
//  Haruby-iOS
//
//  Created by namdghyun on 10/15/24.
//

import UIKit
import SnapKit

final class MainFooterView: UIView {
    // MARK: - UI Components
    lazy var navigateCalculatorButton: NavigationButton = {
        let button = NavigationButton()
        button.customTitleLabel.text = "하루비 계산기"
        button.customSubTitleLabel.text = "지금 지출이 앞으로의 하루비에 얼마나 영향을 줄까요?"
        button.symbolImageView.image = UIImage(systemName: "plus.forwardslash.minus")
        return button
    }()
    
    lazy var navigateCalendarButton: NavigationButton = {
        let button = NavigationButton()
        button.customTitleLabel.text = "하루비 달력"
        button.customSubTitleLabel.text = "하루비 확인 및 조정"
        button.symbolImageView.image = UIImage(systemName: "calendar")
        return button
    }()
    
    lazy var navigateManagementButton: NavigationButton = {
        let button = NavigationButton()
        button.customTitleLabel.text = "하루비 관리"
        button.customSubTitleLabel.text = "고정지출 및 수입 관리"
        button.symbolImageView.image = UIImage(systemName: "wonsign")
        return button
    }()
    
    lazy var navigateStackView: UIStackView = {
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
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    private func setupView() {
        setupSubViews()
        setupConstraints()
    }
    
    private func setupSubViews() {
        addSubview(navigateCalculatorButton)
        addSubview(navigateStackView)
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
}
