//
//  HarubyOrTransactionSelectorViewController.swift
//  Haruby-iOS
//
//  Created by 신승재 on 10/15/24.
//

import UIKit

import RxCocoa
import RxSwift
import ReactorKit
import SnapKit


final class HarubyOrTransactionSelectorViewController: UIViewController, View {

    // MARK: - Properties
    var disposeBag = DisposeBag()
    typealias Reactor = HarubyOrTransactionSelectorViewReactor
    private let horizontalPadding: CGFloat = 16
    
    // MARK: - UI Components
    private let navigateHarubyButton: NavigationButton = {
        let button = NavigationButton()
        button.customTitleLabel.text = "하루비 조정하기"
        button.customSubTitleLabel.text = "오늘의 하루비를 조정하고, 메모를 남겨요"
        button.symbolImageView.image = UIImage(systemName: "arrow.up.arrow.down")
        button.circleView.backgroundColor = .Haruby.white
        button.backgroundColor = .Haruby.whiteDeep
        button.labelStackView.spacing = 4
        button.configure(circleLeftPadding: 16, circleRightPadding: 14)
        
        return button
    }()
    
    private let navigateTransactionButton: NavigationButton = {
        let button = NavigationButton()
        button.customTitleLabel.text = "지출 및 수입 입력하기"
        button.customSubTitleLabel.text = "오늘의 실제 지출 혹은 수입을 입력해요"
        button.symbolImageView.image = UIImage(systemName: "wonsign")
        button.circleView.backgroundColor = .Haruby.white
        button.backgroundColor = .Haruby.whiteDeep
        button.labelStackView.spacing = 4
        button.configure(circleLeftPadding: 16, circleRightPadding: 14)
        
        return button
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupView()
    }
    
    // MARK: - setup
    private func setupView() {
        title = Date().formattedDateToStringforMainView
        view.backgroundColor = .Haruby.white
        
        setupAddSubviews()
        setupConstraints()
    }
    
    private func setupAddSubviews() {
        view.addSubview(navigateHarubyButton)
        view.addSubview(navigateTransactionButton)
    }
    
    private func setupConstraints() {
        navigateHarubyButton.snp.makeConstraints { make in
            make.height.equalTo(105)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(40)
            make.horizontalEdges.equalToSuperview().inset(horizontalPadding)
        }
        
        navigateTransactionButton.snp.makeConstraints { make in
            make.height.equalTo(105)
            make.top.equalTo(navigateHarubyButton.snp.bottom).offset(12)
            make.horizontalEdges.equalToSuperview().inset(horizontalPadding)
        }
    }
    
    // MARK: - Binding
    func bind(reactor: HarubyOrTransactionSelectorViewReactor) {
        // code
    }
}

extension HarubyOrTransactionSelectorViewController {
    // MARK: - Private Methods
}
