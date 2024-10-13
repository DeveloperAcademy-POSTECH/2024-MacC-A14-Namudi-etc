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
        label.font = .pretendardMedium_14()
        label.textAlignment = .center
        label.text = "다음 월급까지의 평균 하루비는 "
        return label
    }()
    
    private lazy var topAvgHarubyText2: UILabel = {
        let label = UILabel()
        label.textColor = .Haruby.whiteDeep50
        label.font = .pretendardSemibold_14()
        label.textAlignment = .center
        label.text = "-"
        return label
    }()
    
    private lazy var topAvgHarubyText3: UILabel = {
        let label = UILabel()
        label.textColor = .Haruby.whiteDeep50
        label.font = .pretendardMedium_14()
        label.textAlignment = .center
        label.text = "입니다 "
        return label
    }()
    
    private lazy var topAvgHarubyIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "info.circle")
        imageView.tintColor = .Haruby.whiteDeep50
        imageView.snp.makeConstraints { make in
            make.width.height.equalTo(17)
        }
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
    
    private lazy var navigateCalculatorButton = NavigationButton(
        title: "하루비 계산기",
        subtitle: "지금 지출이 앞으로의 하루비에 얼마나 영향을 줄까요?",
        symbolName: "plus.forwardslash.minus"
    )
    
    private lazy var navigateCalendarButton = NavigationButton(
        title: "하루비 달력",
        subtitle: "하루비 확인 및 조정",
        symbolName: "calendar"
    )
    
    private lazy var navigateManagementButton = NavigationButton(
        title: "하루비 관리",
        subtitle: "고정지출 및 수입 관리",
        symbolName: "wonsign"
    )
    
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
        setupConstraints()
        setupHeroAnimations()
        
        reactor?.action.onNext(.viewDidLoad)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        animateViewsSequentially()
    }
    
    // MARK: - Setup
    private func setupView() {
        view.backgroundColor = .Haruby.whiteDeep
        view.addSubview(backgroundRectangle)
        view.addSubview(backgroundEllipse)
        view.addSubview(topAvgHarubyStackView)
        view.addSubview(receiptView)
        view.addSubview(navigateCalculatorButton)
        view.addSubview(navigateStackView)
        
        [topAvgHarubyStackView, receiptView, navigateCalculatorButton, navigateStackView].forEach {
            $0.transform = CGAffineTransform(translationX: 0, y: view.bounds.height)
        }
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
        
        topAvgHarubyStackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(receiptView.snp.top).offset(-9)
        }

        receiptView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(142)
            make.left.right.equalToSuperview().inset(16)
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
            make.height.equalTo(66)
        }
    }
    
    // MARK: - Binding
    func bind(reactor: MainReactor) {
        // Action
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
        
        // State
        reactor.state.map { $0.avgHaruby }
            .distinctUntilChanged()
            .bind(to: topAvgHarubyText2.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.todayHaruby }
            .distinctUntilChanged()
            .bind(to: receiptView.amountLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.date }
            .distinctUntilChanged()
            .bind(to: receiptView.dateLabel.rx.text)
            .disposed(by: disposeBag)
    }
}

// MARK: - Animation
extension MainViewController {
    private func setupHeroAnimations() {
        self.hero.isEnabled = true
        
        [topAvgHarubyStackView, receiptView, navigateCalculatorButton, navigateStackView].forEach {
            $0.hero.modifiers = [.translate(y: view.bounds.height)]
        }
    }
    
    private func animateViewsSequentially() {
        let views = [topAvgHarubyStackView, receiptView, navigateCalculatorButton, navigateStackView]
        let delay: TimeInterval = 0.15
        
        for (index, view) in views.enumerated() {
            UIView.animate(withDuration: 0.5, delay: delay * Double(index), options: .curveEaseOut, animations: {
                view.transform = .identity
            })
        }
    }
}
