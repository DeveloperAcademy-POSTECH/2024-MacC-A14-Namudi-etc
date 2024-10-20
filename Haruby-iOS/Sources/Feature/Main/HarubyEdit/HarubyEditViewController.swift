//
//  HarubyEditViewController.swift
//  Haruby-iOS
//
//  Created by 신승재 on 10/12/24.
//

import UIKit
import RxSwift
import RxCocoa
import ReactorKit
import SnapKit

final class HarubyEditViewController: UIViewController, View {
    
    // MARK: - Properties
    var disposeBag: DisposeBag = DisposeBag()
    typealias Reactor = HarubyEditViewReactor
    
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
    
    private lazy var harubyTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "하루비"
        label.font = .pretendardMedium_14
        label.textColor = .Haruby.textBlack
        return label
    }()
    
    private lazy var harubyTextField: RoundedTextField = {
        let textField = RoundedTextField()
        textField.placeholder = "36,900원"
        textField.keyboardType = .numberPad
        textField.textField.tintColor = .clear
        textField.textField.delegate = self
        return textField
    }()
    
    private lazy var memoTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "메모"
        label.font = .pretendardMedium_14
        label.textColor = .Haruby.textBlack
        return label
    }()
    
    private lazy var memoTextField: RoundedTextField = {
        let textField = RoundedTextField()
        return textField
    }()
    
    private lazy var memoFooterLabel: UILabel = {
        let label = UILabel()
        label.text = "(0/30)"
        label.font = .pretendardMedium_14
        label.textColor = .Haruby.textBlack40
        return label
    }()
    
    private lazy var bottomButton: BottomButton = {
        let button = BottomButton()
        button.title = "저장하기"
        return button
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupView()
    }
    
    //MARK: - setup
    private func setupView() {
        view.backgroundColor = .Haruby.white
        
        setupNavigationBar()
        setupSubviews()
        setupConstraints()
        setupTapGesture()
    }
    
    private func setupSubviews() {
        view.addSubview(harubyTitleLabel)
        view.addSubview(harubyTextField)
        view.addSubview(memoTitleLabel)
        view.addSubview(memoTextField)
        view.addSubview(memoFooterLabel)
        view.addSubview(bottomButton)
    }
    
    private func setupConstraints() {
        harubyTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(40)
            make.leading.equalToSuperview().offset(29)
        }
        
        harubyTextField.snp.makeConstraints { make in
            make.top.equalTo(harubyTitleLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        
        memoTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(harubyTextField.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(29)
        }
        
        memoTextField.snp.makeConstraints { make in
            make.top.equalTo(memoTitleLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        
        memoFooterLabel.snp.makeConstraints { make in
            make.top.equalTo(memoTextField.snp.bottom).offset(8)
            make.trailing.equalToSuperview().offset(-30)
        }
        
        bottomButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
        }
    }
    
    // MARK: - Binding
    func bind(reactor: HarubyEditViewReactor) {
        bindState(reactor: reactor)
        bindAction(reactor: reactor)
    }
    
    private func bindState(reactor: HarubyEditViewReactor) {
        
        reactor.state.map{ $0.dailyBudget?.haruby?.decimalWithWon }
            .bind(to: harubyTextField.textField.rx.placeholder)
                    .disposed(by: disposeBag)
        
        reactor.state.map{ $0.harubyText }
            .bind(to: harubyTextField.textField.rx.text)
                    .disposed(by: disposeBag)
        
        reactor.state.map{ $0.memoText }
            .bind(to: memoTextField.textField.rx.text)
                    .disposed(by: disposeBag)
        
        reactor.state.map{ $0.memoText.count }
                    .distinctUntilChanged()
                    .map{ "\($0)/30" }
                    .bind(to: memoFooterLabel.rx.text)
                    .disposed(by: disposeBag)
    }
    
    private func bindAction(reactor: HarubyEditViewReactor) {
        
        closeButton.rx.tap
            .bind{ [weak self] in
                self?.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
        
        harubyTextField.textField.rx.text
                    .orEmpty
                    .map{ Reactor.Action.editHarubyText($0) }
                    .bind(to: reactor.action)
                    .disposed(by: disposeBag)
        
        harubyTextField.textField.rx.text
                    .orEmpty
                    .subscribe(onNext: { [unowned self] _ in
                        self.textFieldDidChangeSelection(self.harubyTextField.textField)
                    })
                    .disposed(by: disposeBag)
        
        memoTextField.textField.rx.text
                    .orEmpty
                    .distinctUntilChanged()
                    .map{ Reactor.Action.editMemoText($0) }
                    .bind(to: reactor.action)
                    .disposed(by: disposeBag)
        
        bottomButton.rx.tap
                    .map{ Reactor.Action.bottomButtonTapped }
                    .bind(to: reactor.action)
                    .disposed(by: disposeBag)
    }
    
    private func setupNavigationBar() {
        title = "하루비 조정"
        navigationItem.rightBarButtonItem = closeBarButtonItem
        let textFont = UIFont.pretendardSemibold_20
        let textColor = UIColor.Haruby.textBlack
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font : textFont,
                                                                        NSAttributedString.Key.foregroundColor: textColor]
    }
}

extension HarubyEditViewController {
    // MARK: - Private Methods
    // 빈공간 터치 했을때 키보드 내리는 메서드
    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
   
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}


extension HarubyEditViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        let endPosition = textField.endOfDocument
        if let newPosition = textField.position(from: endPosition, offset: -1) {
            textField.selectedTextRange = textField.textRange(from: newPosition, to: newPosition)
        }
    }
}
