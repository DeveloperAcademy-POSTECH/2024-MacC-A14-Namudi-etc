//
//  CalculationViewController.swift
//  Haruby-iOS
//
//  Created by 이정동 on 10/13/24.
//

import UIKit
import SnapKit
import ReactorKit
import RxSwift
import RxCocoa

final class CalculatorViewController: UIViewController, View, CoordinatorCompatible {
    
    typealias Reactor = CalculatorViewReactor
    
    // MARK: - Properties
    weak var coordinator: CalculatorCoordinator?
    var disposeBag = DisposeBag()
    var didFinish: (() -> Void)?
    
    // MARK: - UI Components
    private lazy var headerStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [topLabel, bottomStackView])
        view.axis = .vertical
        view.spacing = 6
        view.alignment = .leading
        view.distribution = .fill
        return view
    }()
    
    private lazy var topLabel: UILabel = {
        let view = UILabel()
        view.font = .pretendardSemibold_24
        view.text = "고민 중인 지출의 금액을"
        view.numberOfLines = 2
        view.textColor = .white
        return view
    }()
    
    private lazy var bottomStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [bottomImageView, bottomLabelStackView])
        view.axis = .horizontal
        view.spacing = 5
        view.alignment = .center
        view.distribution = .fill
        return view
    }()
    
    private lazy var bottomImageView: UIImageView = {
        let view = UIImageView()
        view.image = .whiteHaruby
        view.contentMode = .scaleAspectFit
        view.isHidden = true
        return view
    }()
    
    private lazy var bottomLabelStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [bottomPriceLabel, bottomLabel])
        view.axis = .horizontal
        view.spacing = 5
        view.alignment = .firstBaseline
        view.distribution = .fill
        return view
    }()
    
    private lazy var bottomPriceLabel: UILabel = {
        let view = UILabel()
        view.font = .pretendardSemibold_36
        view.text = "\(12000.decimalWithWon)"
        view.textColor = .white
        view.isHidden = true
        view.baselineAdjustment = .alignBaselines
        
        return view
    }()
    
    private lazy var bottomLabel: UILabel = {
        let view = UILabel()
        view.font = .pretendardSemibold_24
        view.text = "입력해 주세요"
        view.numberOfLines = 2
        view.textColor = .white
        return view
    }()
    
    private lazy var bottomView: UIView = {
        let view = UIView()
        view.backgroundColor = .Haruby.white
        return view
    }()
    
    private lazy var calculationProcessView: CalculatorProcessView = {
        let view = CalculatorProcessView()
        return view
    }()
    
    private lazy var inputField: RoundedTextField = {
        let view = RoundedTextField()
        view.placeholder = "금액을 입력해 주세요"
        view.isUserInteractionEnabled = false
        return view
    }()
    
    private lazy var calculationKeypad: CalculatorKeypadView = {
        let view = CalculatorKeypadView()
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }
    
    deinit {
        didFinish?()
    }

    // MARK: - Setup View
    private func setupView() {
        view.backgroundColor = .Haruby.main
        
        setupSubviews()
        setupConstraints()
        setupNavigationBar()
        setupInitialViewData()
    }
    
    private func setupSubviews() {
        
        view.addSubview(headerStackView)
        view.addSubview(bottomView)
        
        bottomView.addSubview(calculationProcessView)
        bottomView.addSubview(inputField)
        bottomView.addSubview(calculationKeypad)
        
        bottomView.roundCorners(cornerRadius: 20, maskedCorners: [.topLeft, .topRight])
    }
    
    private func setupConstraints() {
        headerStackView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(32)
            make.horizontalEdges.equalToSuperview().inset(26)
        }
        
        bottomImageView.snp.makeConstraints { make in
//            make.width.equalTo(50)
//            make.height.equalTo(43)
            make.width.equalTo(35)
            make.height.equalTo(30)
        }
        
        bottomView.snp.makeConstraints { make in
            make.top.equalTo(headerStackView.snp.top).inset(100)
            make.horizontalEdges.bottom.equalToSuperview()
        }
        
        calculationProcessView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(22)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        
        inputField.snp.makeConstraints { make in
            make.bottom.equalTo(calculationKeypad.snp.top)
                .offset(-12)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        
        calculationKeypad.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
        }
    }
    
    // MARK: - Binding
    
    func bind(reactor: Reactor) {
        bindState(reactor: reactor)
        bindAction(reactor: reactor)
    }
    
    private func bindState(reactor: Reactor) {
        
        // 계산된 평균 하루비, 지출 예정 금액
        Observable.zip(
            reactor.state.map { $0.averageHaruby.decimalWithWon },
            reactor.state.map { $0.estimatedPrice.decimalWithWon }
        )
        .subscribe { [weak self] haruby, price in
            self?.bottomPriceLabel.text = haruby
            self?.calculationProcessView.estimatedPrice.text = price
        }
        .disposed(by: disposeBag)
        
        // 계산식
        reactor.state.map { $0.inputFieldText }
            .distinctUntilChanged()
            .bind(to: inputField.textField.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.isResultButtonClicked }
            .distinctUntilChanged()
            .filter { $0 }
            .subscribe { [weak self] _ in
                self?.updateTopView()
            }
            .disposed(by: disposeBag)
    }
    
    private func bindAction(reactor: Reactor) {
        let observableButtons = calculationKeypad.keypadButtons.map { button in
            button.rx.tap.map { _ in
                Reactor.Action.keypadButtonTapped(KeypadButtonType(rawValue: button.tag)!)
            }
        }
        
        Observable.merge(observableButtons)
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
}

extension CalculatorViewController {
    private func setupNavigationBar() {
        title = "하루비 계산기"
        
        self.navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.white
        ]
    }
    
    private func setupInitialViewData() {
        guard let currentState = self.reactor?.currentState else { return }
        
        self.calculationProcessView.totalHaruby.text = currentState.remainTotalHaruby.decimalWithWon
        self.calculationProcessView.remainingDay.text = "\(currentState.remainingDays)일"
    }
    
    private func updateTopView() {
        bottomImageView.isHidden = false
        bottomPriceLabel.isHidden = false
        
        topLabel.text = "지출 후 바뀔 평균 하루비는"
        bottomLabel.text = "입니다"
        
        bottomPriceLabel.font = .pretendardSemibold_36
        bottomLabel.font = .pretendardSemibold_32
    }
}
