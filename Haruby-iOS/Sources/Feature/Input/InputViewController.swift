//
//  InputViewController.swift
//  Haruby-iOS
//
//  Created by Seo-Jooyoung on 10/10/24.
//

import UIKit
import ReactorKit
import RxSwift
import RxCocoa
import SnapKit

class InputViewController: UIViewController, View {
    // MARK: - Properties
    var disposeBag = DisposeBag()
    typealias Reactor = InputViewReactor
    
    let segmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: ["지출", "수입"])
        return control
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.text = "날짜"
        label.textColor = .Haruby.textBlack
        label.font = .pretendardMedium_20
        return label
    }()
    
    private lazy var datePickerButton: UIButton = {
        let button = UIButton()
        button.setTitle("2024.09.28", for: .normal)
        button.setTitleColor(.Haruby.main, for: .normal)
        button.titleLabel?.font = .pretendardRegular_20
        return button
    }()
    
    private lazy var dateStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [self.dateLabel, self.datePickerButton])
        view.axis = .horizontal
        view.alignment = .fill
        view.spacing = 195
        
        return view
    }()
    
    private lazy var amountTextField : RoundedTextField = {
        let textField = RoundedTextField()
        // default값, 아래 bind()에서 '지출' '수입'을 바꿔주도록 함
        textField.placeholder = "총 지출 금액을 입력하세요"
        textField.keyboardType = .numberPad
        return textField
    }()
    
    private lazy var detailInputButton: UIButton = {
        let button = UIButton()
        button.setTitle("상세 내역 기록하기", for: .normal)
        button.setTitleColor(.Haruby.textBright, for: .normal)
        button.titleLabel?.font = .pretendardMedium_14
        return button
    }()
    
    private lazy var detailInputChevron: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        button.tintColor = .Haruby.textBright
        button.titleLabel?.font = .systemFont(ofSize: 14)
        return button
    }()
    
    private lazy var detailInputButtonStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [self.detailInputButton, self.detailInputChevron])
        view.axis = .horizontal
        view.alignment = .fill
        view.spacing = 2
        return view
    }()
    
//    private let bottomButtonView = BottomButton()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setupView()
        
        let tapGestureKeyBoard = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGestureKeyBoard)
        
    }
    
    // MARK: - UI Setup
    private func setupView() {
        setupSubviews()
        setupConstraints()
        setupNavigationBar()

        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(segmentedControlChanged), for: .valueChanged)
    }
    
    private func setupSubviews() {
        self.view.addSubview(segmentedControl)
        self.view.addSubview(dateStackView)
        self.view.addSubview(amountTextField)
        self.view.addSubview(detailInputButtonStackView)
//        self.view.addSubview(bottomButtonView)
        
    }
    
    private func setupConstraints() {
        segmentedControl.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(39)
            make.height.equalTo(28)
        }
        
        dateStackView.snp.makeConstraints { make in
            make.top.equalTo(self.segmentedControl.snp.bottom).offset(58)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(24)
        }
        
        amountTextField.snp.makeConstraints { make in
            make.top.equalTo(self.dateStackView.snp.bottom).offset(32)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
        
        detailInputButtonStackView.snp.makeConstraints { make in
            make.top.equalTo(self.amountTextField.snp.bottom).offset(10)
            make.leading.equalTo(view.safeAreaLayoutGuide).inset(28)
        }
        
//        bottomButtonView.snp.makeConstraints { make in
//            make.leading.trailing.equalToSuperview()
//            make.bottom.equalTo(view.snp.bottom)
//        }
    }
    
    private func setupNavigationBar() {
        title = "지출 및 수입 입력"
        
        self.navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.black
        ]
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func bind(reactor: InputViewReactor) {
        detailInputChevron.rx.tap
            .map { Reactor.Action.toggleDetailButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        detailInputButton.rx.tap
            .map { Reactor.Action.toggleDetailButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        datePickerButton.rx.tap
            .map { Reactor.Action.toggleDatePicker }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        reactor.state
            .map { $0.isDetailVisible }
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] isVisible in
                guard let self = self else { return }
                
                let angle: CGFloat = isVisible ? .pi : 0
                UIView.animate(withDuration: 0.1) {
                    self.detailInputChevron.transform = CGAffineTransform(rotationAngle: angle)
                }
            })
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.isDatePickerVisible }
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] isVisible in
                guard let self = self else { return }
                
                self.presentSheet()
            })
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.transactionType }  // Observe transactionType changes
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] newType in
                self?.amountTextField.placeholder = "총 \(newType) 금액을 입력하세요"
            })
            .disposed(by: disposeBag)
    }
    
    private func presentSheet() {
        let sheetViewController = DatePickerSheet()
        sheetViewController.modalPresentationStyle = .pageSheet
        
        if let sheet = sheetViewController.sheetPresentationController {
            let customDetent = UISheetPresentationController.Detent.custom { context in
                return 400
            }
            sheet.detents = [customDetent]
            sheet.prefersGrabberVisible = false
        }
        
        present(sheetViewController, animated: true, completion: nil)
    }
    
    @objc private func segmentedControlChanged() {
        let newType = segmentedControl.selectedSegmentIndex == 0 ? "지출" : "수입"
        reactor?.action.onNext(.selectTransactionType(newType))
    }
}
