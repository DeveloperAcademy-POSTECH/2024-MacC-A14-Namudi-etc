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

final class TransactionInputViewController: UIViewController, View {
    // MARK: - Properties
    var disposeBag = DisposeBag()
    typealias Reactor = TransactionInputViewReactor
    
    private lazy var segmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: [
            TransactionType.expense.text, TransactionType.income.text
        ])
        control.selectedSegmentIndex = TransactionType.expense.rawValue
        return control
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.text = "날짜"
        label.textColor = .Haruby.textBlack
        label.font = .pretendardMedium_20
        label.textAlignment = .left
        return label
    }()
    
    private lazy var datePickerButton: UIButton = {
        let button = UIButton()
        button.setTitle("2024.09.28", for: .normal)
        button.setTitleColor(.Haruby.main, for: .normal)
        button.titleLabel?.font = .pretendardRegular_20
        button.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        button.titleLabel?.textAlignment = .right
        return button
    }()
    
    private lazy var dateStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [self.dateLabel, self.datePickerButton])
        view.axis = .horizontal
        view.alignment = .fill
        
        return view
    }()
    
    private lazy var totalPriceTextField : RoundedTextField = {
        let textField = RoundedTextField()
        textField.placeholder = "총 지출 금액을 입력하세요"
        textField.keyboardType = .numberPad
        textField.textField.tintColor = .clear
        textField.textField.delegate = self
        return textField
    }()
    
    private lazy var detailInputButton: UIButton = {
        let button = UIButton()
        button.setTitle("상세 내역 기록하기 ", for: .normal)
        button.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        button.imageView?.tintColor = .Haruby.textBright
        button.setTitleColor(.Haruby.textBright, for: .normal)
        button.titleLabel?.font = .pretendardMedium_14
        button.semanticContentAttribute = .forceRightToLeft
        return button
    }()
    
    private lazy var detailTransactionTableView: UITableView = {
        let view = UITableView()
        view.register(
            DetailInputCell.self,
            forCellReuseIdentifier: DetailInputCell.cellId
        )
        view.estimatedRowHeight = 49
        view.separatorStyle = .none
        view.isScrollEnabled = true
        return view
    }()
    
    private lazy var addDetailTransactionButton: UIButton = {
        let button = UIButton()
        button.setTitle("+ 지출 추가", for: .normal)
        button.setTitleColor(.Haruby.main, for: .normal)
        button.titleLabel?.font = .pretendardMedium_16
        return button
    }()
    
    private let bottomButton: BottomButton = {
        let button = BottomButton()
        button.title = "저장하기"
        return button
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    // MARK: - UI Setup
    private func setupView() {
        view.backgroundColor = .Haruby.white
        
        setupSubviews()
        setupConstraints()
        setupNavigationBar()
        setupKeyboardDismissGesture()
    }
    
    private func setupSubviews() {
        self.view.addSubview(segmentedControl)
        self.view.addSubview(dateStackView)
        self.view.addSubview(totalPriceTextField)
        self.view.addSubview(detailInputButton)
        self.view.addSubview(detailTransactionTableView)
        self.view.addSubview(addDetailTransactionButton)
        self.view.addSubview(bottomButton)
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
        
        totalPriceTextField.snp.makeConstraints { make in
            make.top.equalTo(self.dateStackView.snp.bottom).offset(32)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
        
        detailInputButton.snp.makeConstraints { make in
            make.top.equalTo(self.totalPriceTextField.snp.bottom).offset(10)
            make.leading.equalTo(view.safeAreaLayoutGuide).inset(28)
        }
        
        detailTransactionTableView.snp.makeConstraints { make in
            make.top.equalTo(self.detailInputButton.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview()
        }
        
        addDetailTransactionButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.detailTransactionTableView.snp.bottom).offset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-162)
            make.horizontalEdges.equalToSuperview().inset(28)
            make.height.equalTo(35)
        }
        
        bottomButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.snp.bottom)
        }
    }
    
    func bind(reactor: TransactionInputViewReactor) {
        bindState(reactor: reactor)
        bindAction(reactor: reactor)
    }
    
    private func bindState(reactor: Reactor) {
        reactor.state
            .map { $0.isDetailVisible }
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] isVisible in
                guard let self = self else { return }
                
                self.detailTransactionTableView.isHidden = !isVisible
                self.addDetailTransactionButton.isHidden = !isVisible
                
                
                UIView.animate(withDuration: 0.1) {
                    self.detailInputButton.setImage(isVisible
                                                ? UIImage(systemName: "chevron.up")
                                                : UIImage(systemName: "chevron.down"),
                                                for: .normal)
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
        
        reactor.state.map { $0.isTextFieldEditting }
            .distinctUntilChanged()
            .subscribe { [weak self] _ in
                guard let currentState = self?.reactor?.currentState else { return }
                let total = currentState.transactionType == .expense
                ? currentState.dailyBudget.expense.total
                : currentState.dailyBudget.income.total
                
                self?.totalPriceTextField.textField.text = total.decimalWithWon
            }
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.transactionType }  // Observe transactionType changes
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] newType in
                guard let self = self else { return }
                let dailyBudget = self.reactor?.currentState.dailyBudget
                
                self.totalPriceTextField.textField.text = newType == .expense
                ? dailyBudget?.expense.total.decimalWithWon
                : dailyBudget?.income.total.decimalWithWon
                self.totalPriceTextField.placeholder = "총 \(newType.text) 금액을 입력하세요"
                self.addDetailTransactionButton.setTitle("+ \(newType.text) 추가", for: .normal)
            })
            .disposed(by: disposeBag)
        
        reactor.state
            .map {
                $0.transactionType == .expense
                ? $0.dailyBudget.expense.transactionItems
                : $0.dailyBudget.income.transactionItems
            }
            .distinctUntilChanged()
            .bind(to: detailTransactionTableView.rx.items(
                cellIdentifier: DetailInputCell.cellId,
                cellType: DetailInputCell.self
            )) { [weak self] (row, transaction, cell) in
                let type = self?.reactor?.currentState.transactionType
                cell.detailNameTextField.textField.placeholder = (type?.text ?? "") + " 이름"
                cell.detailAmountTextField.textField.placeholder = (type?.text ?? "") + " 금액"

            }
            .disposed(by: disposeBag)
        
        detailTransactionTableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
    }
    
    private func bindAction(reactor: Reactor) {
        detailInputButton.rx.tap
            .map { Reactor.Action.detailButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        datePickerButton.rx.tap
            .map { Reactor.Action.datePickerTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        addDetailTransactionButton.rx.tap
            .map { Reactor.Action.addingTransactionButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        segmentedControl.rx.selectedSegmentIndex
            .map {
                let newType = TransactionType(rawValue: $0) ?? .expense
                return Reactor.Action.transactionTypeButtonTapped(newType)
            }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        totalPriceTextField.textField.rx.text.orEmpty
            .map { Reactor.Action.totalPriceTextFieldEditting($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        bottomButton.rx.tap
            .map { Reactor.Action.saveButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
}

extension TransactionInputViewController {
    private func presentSheet() {
        let sheetViewController = DatePickerView()
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
    
    private func setupNavigationBar() {
        title = "지출 및 수입 입력"
        
        self.navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.black
        ]
    }
    
    private func setupKeyboardDismissGesture() {
        let tapGestureKeyBoard = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGestureKeyBoard)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension TransactionInputViewController: UITableViewDelegate {
    
}

extension TransactionInputViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        let newPosition = textField.endOfDocument
        textField.selectedTextRange = textField.textRange(from: newPosition, to: newPosition)
    }
}
