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
import Hero

final class MainViewController: UIViewController, View {
    // MARK: - Properties
    var disposeBag = DisposeBag()
    
    // MARK: - UI Components
    private lazy var topAvgHarubyText1: UILabel = {
        let label = UILabel()
        label.textColor = .Haruby.whiteDeep50
        label.font = .pretendardMedium_14
        label.textAlignment = .center
        label.text = "다음 월급까지의 평균 하루비는 "
        return label
    }()
    
    private lazy var topAvgHarubyText2: UILabel = {
        let label = UILabel()
        label.textColor = .Haruby.whiteDeep50
        label.font = .pretendardSemibold_14
        label.textAlignment = .center
        label.text = "-"
        return label
    }()
    
    private lazy var topAvgHarubyText3: UILabel = {
        let label = UILabel()
        label.textColor = .Haruby.whiteDeep50
        label.font = .pretendardMedium_14
        label.textAlignment = .center
        label.text = "입니다 "
        return label
    }()
    
    private lazy var topAvgHarubyIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "info.circle")
        imageView.tintColor = .Haruby.whiteDeep50
        return imageView
    }()
    
    private lazy var topAvgHarubyStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            topAvgHarubyText1, topAvgHarubyText2, topAvgHarubyText3, topAvgHarubyIcon
        ])
        stackView.axis = .horizontal
        stackView.spacing = 0
        stackView.alignment = .center
        return stackView
    }()
    
    private lazy var receiptView: ReceiptView = {
        let view = ReceiptView(frame: .zero)
        return view
    }()
    
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
    
    private let navigateCalculatorButton: NavigationButton = {
        let button = NavigationButton()
        button.customTitleLabel.text = "하루비 계산기"
        button.customSubTitleLabel.text = "지금 지출이 앞으로의 하루비에 얼마나 영향을 줄까요?"
        button.symbolImageView.image = UIImage(systemName: "plus.forwardslash.minus")
        
        return button
    }()
    
    private let navigateCalendarButton: NavigationButton = {
        let button = NavigationButton()
        button.customTitleLabel.text = "하루비 달력"
        button.customSubTitleLabel.text = "하루비 확인 및 조정"
        button.symbolImageView.image = UIImage(systemName: "calendar")
        
        return button
    }()
    
    private let navigateManagementButton: NavigationButton = {
        let button = NavigationButton()
        button.customTitleLabel.text = "하루비 관리"
        button.customSubTitleLabel.text = "고정지출 및 수입 관리"
        button.symbolImageView.image = UIImage(systemName: "wonsign")
        
        return button
    }()
    
    private lazy var navigateStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [navigateCalendarButton, navigateManagementButton])
        stackView.axis = .horizontal
        stackView.spacing = 9
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    // MARK: - Initializer
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
        reactor?.action.onNext(.viewDidLoad)
    }
    
    // MARK: - Setup
    private func setupView() {
        view.backgroundColor = .Haruby.whiteDeep
        
        setupSubviews()
        setupConstraints()
    }
    
    private func setupSubviews() {
        view.addSubview(backgroundRectangle)
        view.addSubview(backgroundEllipse)
        view.addSubview(topAvgHarubyStackView)
        view.addSubview(receiptView)
        view.addSubview(navigateCalculatorButton)
        view.addSubview(navigateStackView)
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
        
        topAvgHarubyIcon.snp.makeConstraints { make in
            make.width.height.equalTo(17)
        }
        
        topAvgHarubyStackView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(62)
            make.centerX.equalToSuperview()
        }

        receiptView.snp.makeConstraints { make in
            make.top.equalTo(topAvgHarubyStackView.snp.bottom).offset(9)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(331)
        }
        
        navigateCalculatorButton.snp.makeConstraints { make in
            make.top.equalTo(receiptView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(106)
        }
        
        navigateStackView.snp.makeConstraints { make in
            make.top.equalTo(navigateCalculatorButton.snp.bottom).offset(11)
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.lessThanOrEqualToSuperview().offset(-20)
            make.height.equalTo(66)
        }
    }
    
    // MARK: - Binding
    func bind(reactor: MainReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    func bindAction(reactor: MainReactor) {
        navigateCalculatorButton.rx.tap
            .map { Reactor.Action.naivgateCalculator }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        navigateCalendarButton.rx.tap
            .map { Reactor.Action.navigateCalendar }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        navigateManagementButton.rx.tap
            .map { Reactor.Action.navigateManagement }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        receiptView.inputButton.rx.tap
            .map { Reactor.Action.navigateInputButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    func bindState(reactor: MainReactor) {
        reactor.state.map { $0.mainState.todayHarubyTitle }
            .distinctUntilChanged()
            .bind(to: receiptView.titleLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.mainState.avgHaruby }
            .distinctUntilChanged()
            .bind(to: topAvgHarubyText2.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.mainState.todayHaruby }
            .distinctUntilChanged()
            .bind(to: receiptView.amountLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.mainState.date }
            .distinctUntilChanged()
            .bind(to: receiptView.dateLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.mainState.harubyImage }
            .distinctUntilChanged()
            .bind(to: receiptView.harubyImageView.rx.image)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.mainState.amountBoxColor }
            .distinctUntilChanged()
            .bind(to: receiptView.amountBox.rx.backgroundColor)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.mainState.amountLabelColor }
            .distinctUntilChanged()
            .bind(to: receiptView.amountLabel.rx.textColor)
            .disposed(by: disposeBag)
        
        // TODO: 사용한 금액 표시 로직 구현
        /*
        reactor.state.map { $0.mainState.usedAmount }
            .distinctUntilChanged()
         */
    }
}
