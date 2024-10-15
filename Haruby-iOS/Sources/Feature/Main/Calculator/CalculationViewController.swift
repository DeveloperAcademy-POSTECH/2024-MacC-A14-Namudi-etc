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

final class CalculationViewController: UIViewController, View {
    
    typealias Reactor = CalculationViewReactor
    
    // MARK: - Properties
    var disposeBag = DisposeBag()
    
    // MARK: - UI Components
    private lazy var topStackView: UIStackView = {
        let view = UIStackView()
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
        let view = UIStackView()
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
        let view = UIStackView()
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
    
    private lazy var calculationProcessView: CalculationProcessView = {
        let view = CalculationProcessView()
        return view
    }()
    
    private lazy var inputField: RoundedTextField = {
        let view = RoundedTextField()
        view.placeholder = "금액을 입력해 주세요"
        view.isUserInteractionEnabled = false
        return view
    }()
    
    private lazy var calculationKeypad: CalculationKeypad = {
        let view = CalculationKeypad()
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }
    

    // MARK: - Setup View
    private func setupView() {
        view.backgroundColor = .Haruby.main
        
        setupSubviews()
        setupConstraints()
        setupNavigationBar()
    }
    
    private func setupSubviews() {
        
        view.addSubview(topStackView)
        
        [topLabel, bottomStackView].forEach { topStackView.addArrangedSubview($0) }
        
        [bottomImageView, bottomLabelStackView].forEach {
            bottomStackView.addArrangedSubview($0)
        }
        
        [bottomPriceLabel, bottomLabel].forEach {
            bottomLabelStackView.addArrangedSubview($0)
        }

        view.addSubview(bottomView)
        
        bottomView.addSubview(calculationProcessView)
        bottomView.addSubview(inputField)
        bottomView.addSubview(calculationKeypad)
        
        bottomView.roundCorners(cornerRadius: 20, maskedCorners: [.topLeft, .topRight])
    }
    
    private func setupConstraints() {
        topStackView.snp.makeConstraints { make in
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
            make.top.equalTo(topStackView.snp.top).inset(100)
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
    
    private func setupNavigationBar() {
        title = "하루비 계산기"
        
        self.navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.white
        ]
    }
    
    // MARK: - Binding
    
    func bind(reactor: Reactor) {
        bindState(reactor: reactor)
        bindAction(reactor: reactor)
    }
    
    private func bindState(reactor: Reactor) {
        // 계산된 평균 하루비
        reactor.state.map { $0.averageHaruby.decimalWithWon }
            .distinctUntilChanged()
            .bind(to: self.bottomPriceLabel.rx.text)
            .disposed(by: disposeBag)
        
        // 남은 총 하루비
        reactor.state.map { $0.remainTotalHaruby.decimalWithWon }
            .distinctUntilChanged()
            .bind(to: self.calculationProcessView.totalHaruby.rx.text)
            .disposed(by: disposeBag)
        
        // 지출 예정 금액
        reactor.state.map { $0.estimatedPrice.decimalWithWon }
            .distinctUntilChanged()
            .bind(to: self.calculationProcessView.estimatedPrice.rx.text)
            .disposed(by: disposeBag)
        
        // 남은 일수
        reactor.state.map { String($0.remainingDays) + "일" }
            .distinctUntilChanged()
            .bind(to: self.calculationProcessView.remainingDay.rx.text)
            .disposed(by: disposeBag)
        
        // 계산식
        reactor.state.map { $0.inputFieldText }
            .distinctUntilChanged()
            .bind(to: inputField.textField.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.isResultButtonClicked }
            .distinctUntilChanged()
//            .filter { $0 }
            .subscribe { [weak self] _ in
                self?.updateTopView()
            }
            .disposed(by: disposeBag)
    }
    
    private func bindAction(reactor: Reactor) {
        var numberButtons = calculationKeypad.numberButtons.map { button in
            button.rx.tap.map { _ in
                Reactor.Action.numberButtonTapped(button.titleLabel!.text!)
            }
        }
        var operatorButtons = calculationKeypad.operatorButtons.map { button in
            button.rx.tap.map { _ in
                Reactor.Action.operatorButtonTapped(button.titleLabel!.text!)
            }
        }
        var deleteButtons = calculationKeypad.deleteButtons.map { button in
            button.rx.tap.map { _ in
                Reactor.Action.deleteButtonTapped(button.titleLabel?.text ?? "")
            }
        }
        
        Observable.merge(numberButtons)
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
            
        Observable.merge(operatorButtons)
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        Observable.merge(deleteButtons)
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
}

extension CalculationViewController {
    private func updateTopView() {
        bottomImageView.isHidden = false
        bottomPriceLabel.isHidden = false
        
        bottomLabel.text = "입니다"
        
        bottomPriceLabel.font = .pretendardSemibold_36
        bottomLabel.font = .pretendardSemibold_32
    }
}
