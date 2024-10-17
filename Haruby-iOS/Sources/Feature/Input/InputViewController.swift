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
    
    private lazy var amountTextField : RoundedTextField = {
        let textField = RoundedTextField()
        // default값, 아래 bind()에서 '지출' '수입'을 바꿔주도록 함
        textField.placeholder = "총 지출 금액을 입력하세요"
        textField.keyboardType = .numberPad
        return textField
    }()
    
    private lazy var detailButton: UIButton = {
        let button = UIButton()
        button.setTitle("상세 내역 기록하기", for: .normal)
        button.setTitleColor(.Haruby.textBright, for: .normal)
        button.titleLabel?.font = .pretendardMedium_14
        return button
    }()
    
    private lazy var detailChevron: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        button.tintColor = .Haruby.textBright
        button.titleLabel?.font = .systemFont(ofSize: 14)
        return button
    }()
    
    private lazy var detailButtonStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [self.detailButton, self.detailChevron])
        view.axis = .horizontal
        view.alignment = .fill
        view.spacing = 2
        return view
    }()
    
    private lazy var detailTransactionTableView: UITableView = {
        let view = UITableView()
        view.register(DetailInputCell.self, forCellReuseIdentifier: DetailInputCell.cellId)
        view.dataSource = self
        view.delegate = self
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
        self.view.addSubview(detailButtonStackView)
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
        
        amountTextField.snp.makeConstraints { make in
            make.top.equalTo(self.dateStackView.snp.bottom).offset(32)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
        
        detailButtonStackView.snp.makeConstraints { make in
            make.top.equalTo(self.amountTextField.snp.bottom).offset(10)
            make.leading.equalTo(view.safeAreaLayoutGuide).inset(28)
        }
        
        detailTransactionTableView.snp.makeConstraints { make in
            make.top.equalTo(self.detailButtonStackView.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview()
        }
        
        addDetailTransactionButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.detailTransactionTableView.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(28)
            make.height.equalTo(35)
        }
        
        bottomButton.snp.makeConstraints { make in
            make.top.equalTo(self.addDetailTransactionButton.snp.bottom).offset(54)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.snp.bottom)
        }
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
        detailChevron.rx.tap
            .map { Reactor.Action.toggleDetailButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        detailButton.rx.tap
            .map { Reactor.Action.toggleDetailButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        datePickerButton.rx.tap
            .map { Reactor.Action.toggleDatePicker }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        addDetailTransactionButton.rx.tap
            .map { Reactor.Action.tapAddDetailTransactionButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        reactor.state
            .map { $0.isDetailVisible }
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] isVisible in
                guard let self = self else { return }
                
                self.detailTransactionTableView.isHidden = !isVisible
                self.addDetailTransactionButton.isHidden = !isVisible
                
                let angle: CGFloat = isVisible ? .pi : 0
                UIView.animate(withDuration: 0.1) {
                    self.detailChevron.transform = CGAffineTransform(rotationAngle: angle)
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
                guard let self = self else { return }
                self.amountTextField.placeholder = "총 \(newType) 금액을 입력하세요"
            })
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.detailTransaction }
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] transactions in
                guard let self = self else { return }
                self.detailTransactionTableView.reloadData()
                
                // 가장 나중에 추가한 cell에 포커스되도록 하는 코드
                if transactions.count > 0 {
                    let lastRowIndex = IndexPath(row: transactions.count - 1, section: 0)
                    self.detailTransactionTableView.scrollToRow(at: lastRowIndex, at: .bottom, animated: true)
                }
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

extension InputViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let cellCount = reactor?.currentState.detailTransaction.count, cellCount > 0 else { return 1 }
        return cellCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DetailInputCell.cellId, for: indexPath) as? DetailInputCell else { return UITableViewCell() }
                
        
        return cell
    }
}
