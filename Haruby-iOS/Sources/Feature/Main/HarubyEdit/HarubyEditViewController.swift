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
        title = "하루비 조정"
        view.backgroundColor = .Haruby.white
        
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
        // Action
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
        // State
        reactor.state.map{ $0.memoText }
            .bind(to: memoTextField.textField.rx.text)
                    .disposed(by: disposeBag)
        
        reactor.state.map{ $0.memoText.count }
                    .distinctUntilChanged()
                    .map{ "\($0)/30" }
                    .bind(to: memoFooterLabel.rx.text)
                    .disposed(by: disposeBag)
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
