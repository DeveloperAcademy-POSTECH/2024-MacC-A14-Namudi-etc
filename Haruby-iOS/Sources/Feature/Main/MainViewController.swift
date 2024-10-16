//
//  MainViewController.swift
//  initProjectWithUIKit-iOS
//
//  Created by namdghyun on 10/4/24.
//

import UIKit
import SnapKit
import ReactorKit
import RxCocoa

final class MainViewController: UIViewController, View {
    // MARK: - Properties
    var disposeBag = DisposeBag()
    
    // MARK: - UI Components
    private lazy var headerView = MainHeaderView()
    private lazy var receiptView: MainReceiptView = {
        let view = MainReceiptView(frame: .zero)
        return view
    }()
    private lazy var footerView = MainFooterView()
    
    private lazy var backgroundRectangle: UIView = {
        let view = UIView()
        view.backgroundColor = .Haruby.main
        return view
    }()
    
    private lazy var backgroundEllipse: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.fillColor = UIColor.Haruby.whiteDeep.cgColor
        
        let path = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: 484, height: 174))
        shapeLayer.path = path.cgPath
        
        view.layer.addSublayer(shapeLayer)
        
        return view
    }()
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
        reactor?.action.onNext(.viewDidLoad)
    }
    
    // MARK: - Setup View
    private func setupView() {
        view.backgroundColor = .Haruby.whiteDeep
        setupSubviews()
        setupConstraints()
    }
    
    private func setupSubviews() {
        [backgroundRectangle, backgroundEllipse, headerView, receiptView, footerView].forEach { view.addSubview($0) }
    }
    
    private func setupConstraints() {
        backgroundRectangle.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.width.equalToSuperview()
            make.bottom.equalTo(backgroundEllipse.snp.centerY)
        }
        
        backgroundEllipse.snp.makeConstraints { make in
            make.centerX.equalToSuperview().offset(-0.5)
            make.top.equalToSuperview().offset(211)
            make.width.equalTo(484)
            make.height.equalTo(174)
        }
        
        headerView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
        }
        
        receiptView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom).offset(9)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(331)
        }
        
        footerView.snp.makeConstraints { make in
            make.top.equalTo(receiptView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.lessThanOrEqualToSuperview().offset(-20)
        }
    }
    
    // MARK: - Binding
    func bind(reactor: MainViewReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    private func bindAction(reactor: MainViewReactor) {
        footerView.navigateCalculatorButton.rx.tap
            .map { Reactor.Action.calculatorButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        footerView.navigateCalendarButton.rx.tap
            .map { Reactor.Action.calendarButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        footerView.navigateManagementButton.rx.tap
            .map { Reactor.Action.managementButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        receiptView.inputButton.rx.tap
            .map { Reactor.Action.inputButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindState(reactor: MainViewReactor) {
        reactor.state.map { $0.viewState.avgAmount.decimalWithWon }
            .distinctUntilChanged()
            .bind(to: headerView.topAvgHarubyText2.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.viewState.title }
            .distinctUntilChanged()
            .bind(to: receiptView.titleLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.viewState.remainingAmount.decimalWithWon }
            .distinctUntilChanged()
            .bind(to: receiptView.amountLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.viewState.date.formattedDateToStringforMainView }
            .distinctUntilChanged()
            .bind(to: receiptView.dateLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.viewState.harubyState.uiProperties.image }
            .distinctUntilChanged()
            .bind(to: receiptView.harubyImageView.rx.image)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.viewState.harubyState.uiProperties.boxColor }
            .distinctUntilChanged()
            .bind(to: receiptView.amountBox.rx.backgroundColor)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.viewState.harubyState.uiProperties.labelColor }
            .distinctUntilChanged()
            .bind(to: receiptView.amountLabel.rx.textColor)
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.viewState.usedAmount == 0 }
            .distinctUntilChanged()
            .bind(to: receiptView.expenseAmountStackView.rx.isHidden)
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.viewState.todayAmount.decimalWithWon }
            .distinctUntilChanged()
            .bind(to: receiptView.expenseAmountText2.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.viewState.usedAmount.decimalWithWon }
            .distinctUntilChanged()
            .bind(to: receiptView.expenseAmountText4.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state
            .map { state -> UIColor in
                state.viewState.usedAmount > state.viewState.todayAmount ? .Haruby.red : .Haruby.green
            }
            .distinctUntilChanged()
            .bind(to: receiptView.expenseAmountText4.rx.textColor)
            .disposed(by: disposeBag)
    }
}
