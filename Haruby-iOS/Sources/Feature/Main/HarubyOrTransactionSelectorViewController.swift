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
    private lazy var closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("닫기", for: .normal)
        button.setTitleColor(.Haruby.main, for: .normal)
        button.titleLabel?.font = .pretendard(size: 18, weight: .bold)
        
        return button
    }()
    
    private lazy var closeBarButtonItem: UIBarButtonItem = {
        return UIBarButtonItem(customView: closeButton)
    }()
    
    private let harubyNavigationButton: NavigationButton = {
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
    
    private let transactionNavigationButton: NavigationButton = {
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
        view.backgroundColor = .Haruby.white
        setupNavigationBar()
        setupAddSubviews()
        setupConstraints()
    }
    
    private func setupAddSubviews() {
        view.addSubview(harubyNavigationButton)
        view.addSubview(transactionNavigationButton)
    }
    
    private func setupConstraints() {
        harubyNavigationButton.snp.makeConstraints { make in
            make.height.equalTo(105)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(40)
            make.horizontalEdges.equalToSuperview().inset(horizontalPadding)
        }
        
        transactionNavigationButton.snp.makeConstraints { make in
            make.height.equalTo(105)
            make.top.equalTo(harubyNavigationButton.snp.bottom).offset(12)
            make.horizontalEdges.equalToSuperview().inset(horizontalPadding)
        }
    }
    
    private func setupNavigationBar() {
        title = Date().formattedDateToStringforMainView
        navigationItem.rightBarButtonItem = closeBarButtonItem
        let textFont = UIFont.pretendardSemibold_20
        let textColor = UIColor.Haruby.textBlack
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font : textFont,
                                                                        NSAttributedString.Key.foregroundColor: textColor]
    }
    
    // MARK: - Binding
    func bind(reactor: HarubyOrTransactionSelectorViewReactor) {
        bindState(reactor: reactor)
        bindAction(reactor: reactor)
    }
    
    private func bindState(reactor: HarubyOrTransactionSelectorViewReactor) {
        reactor.state.map{ ($0.isHarubyButtonTapped, $0.dailyBudget) }
            .bind{ [unowned self] (isHarubyButtonTapped, dailyBudget) in
                if isHarubyButtonTapped {
                    let vc = HarubyEditViewController()
                    vc.reactor = HarubyEditViewReactor(dailyBudget: dailyBudget)
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }.disposed(by: disposeBag)
    }
    
    private func bindAction(reactor: HarubyOrTransactionSelectorViewReactor) {
        closeButton.rx.tap
            .bind{ [unowned self] in
                self.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
        
        harubyNavigationButton.rx.tap
            .map{ Reactor.Action.harubyButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        transactionNavigationButton.rx.tap
            .map{ Reactor.Action.transactionButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
}

extension HarubyOrTransactionSelectorViewController {
    // MARK: - Private Methods
}
