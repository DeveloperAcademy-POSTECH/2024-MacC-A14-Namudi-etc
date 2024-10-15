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
        label.font = .pretendardMedium_14()
        label.textColor = .Haruby.textBlack
        return label
    }()
    
    private lazy var harubyTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "36,900원"
        textField.font = .pretendardSemibold_20()
        textField.textColor = .Haruby.textBlack
        textField.setPlaceholderColor(.Haruby.textBrighter)
        
        return textField
    }()
    
    private lazy var harubyContainerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.Haruby.textBright40.cgColor
        view.addSubview(harubyTextField)
        harubyTextField.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(15)
            make.horizontalEdges.equalToSuperview().inset(14)
        }
        return view
    }()
    
    private lazy var memoTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "메모"
        label.font = .pretendardMedium_14()
        label.textColor = .Haruby.textBlack
        return label
    }()
    
    private lazy var memoTextField: UITextField = {
        let textField = UITextField()
        textField.font = .pretendardSemibold_20()
        textField.textColor = .Haruby.textBlack
        
        return textField
    }()
    
    private lazy var memoContainerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.Haruby.textBright40.cgColor
        view.addSubview(memoTextField)
        memoTextField.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(15)
            make.horizontalEdges.equalToSuperview().inset(14)
        }
        return view
    }()
    
    private lazy var memoFooterLabel: UILabel = {
        let label = UILabel()
        label.text = "(0/30)"
        label.font = .pretendardMedium_14()
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
    
    
    // MARK: - Binding
    func bind(reactor: HarubyEditViewReactor) {
        // Action
        memoTextField.rx.text
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
                    .bind(to: memoTextField.rx.text)
                    .disposed(by: disposeBag)
        
        reactor.state.map{ $0.memoText.count }
                    .distinctUntilChanged()
                    .map{ "\($0)/30" }
                    .bind(to: memoFooterLabel.rx.text)
                    .disposed(by: disposeBag)
    }
    
    //MARK: - setup
    private func setupView() {
        title = "하루비 조정"
        view.backgroundColor = .Haruby.white
        
        addSubviews()
        setupConstraints()
        setupTapGesture()
    }
    
    private func addSubviews() {
        view.addSubview(harubyTitleLabel)
        view.addSubview(harubyContainerView)
        view.addSubview(memoTitleLabel)
        view.addSubview(memoContainerView)
        view.addSubview(memoFooterLabel)
        view.addSubview(bottomButton)
    }
    
    private func setupConstraints() {
        harubyTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(40)
            make.leading.equalToSuperview().offset(29)
        }
        
        harubyContainerView.snp.makeConstraints { make in
            make.top.equalTo(harubyTitleLabel.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
        
        memoTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(harubyContainerView.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(29)
        }
        
        memoContainerView.snp.makeConstraints { make in
            make.top.equalTo(memoTitleLabel.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
        
        memoFooterLabel.snp.makeConstraints { make in
            make.top.equalTo(memoContainerView.snp.bottom).offset(8)
            make.trailing.equalToSuperview().offset(-30)
        }
        
        bottomButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
        }
    }
    
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

