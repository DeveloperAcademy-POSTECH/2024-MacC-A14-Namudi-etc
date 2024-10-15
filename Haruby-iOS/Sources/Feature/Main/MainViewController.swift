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
    func bind(reactor: MainReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    private func bindAction(reactor: MainReactor) {
        footerView.rx.tapCalculator
            .map { Reactor.Action.naivgateCalculator }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        footerView.rx.tapCalendar
            .map { Reactor.Action.navigateCalendar }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        footerView.rx.tapManagement
            .map { Reactor.Action.navigateManagement }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        receiptView.rx.inputButtonTap
            .map { Reactor.Action.navigateInputButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindState(reactor: MainReactor) {
        reactor.state.map { $0.mainState.avgHaruby }
            .distinctUntilChanged()
            .bind(to: headerView.rx.avgHaruby)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.mainState.todayHarubyTitle }
            .distinctUntilChanged()
            .bind(to: receiptView.rx.todayHarubyTitle)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.mainState.remainHaruby }
            .distinctUntilChanged()
            .bind(to: receiptView.rx.remainHaruby)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.mainState.date }
            .distinctUntilChanged()
            .bind(to: receiptView.rx.date)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.mainState.harubyImage }
            .distinctUntilChanged()
            .bind(to: receiptView.rx.harubyImage)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.mainState.amountBoxColor }
            .distinctUntilChanged()
            .bind(to: receiptView.rx.amountBoxColor)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.mainState.amountLabelColor }
            .distinctUntilChanged()
            .bind(to: receiptView.rx.amountLabelColor)
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.mainState.usedAmount > 0 ? false : true }
            .distinctUntilChanged()
            .bind(to: receiptView.rx.expenseAmountStackViewHidden)
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.mainState.todayHaruby }
            .distinctUntilChanged()
            .bind(to: receiptView.rx.todayHaruby)
            .disposed(by: disposeBag)
        
        reactor.state
            .map { state -> String in
                let usedAmount = (state.mainState.todayHaruby.numberFormat ?? 0) - (state.mainState.remainHaruby.numberFormat ?? 0)
                return usedAmount.decimalWithWon
            }
            .distinctUntilChanged()
            .bind(to: receiptView.rx.usedAmount)
            .disposed(by: disposeBag)
        
        reactor.state
            .map { state -> UIColor in
                let usedAmount = (state.mainState.todayHaruby.numberFormat ?? 0) - (state.mainState.remainHaruby.numberFormat ?? 0)
                return state.mainState.usedAmount > 0 && usedAmount > state.mainState.todayHaruby.numberFormat ?? 0 ? .Haruby.red : .Haruby.green
            }
            .distinctUntilChanged()
            .bind(to: receiptView.rx.usedAmountColor)
            .disposed(by: disposeBag)
    }
}
