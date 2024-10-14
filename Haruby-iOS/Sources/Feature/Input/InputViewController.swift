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
    
    private lazy var amountTextField : UITextField = {
        let textField = UITextField()
        textField.placeholder = "총 지출 금액을 입력하세요"
        textField.setPlaceholder(color: .Haruby.textBright40)
        textField.textAlignment = .left
        textField.textColor = .Haruby.textBlack
        textField.font = .pretendardSemibold_20
        textField.borderStyle = .roundedRect
        textField.backgroundColor = .Haruby.white
        textField.keyboardType = .numberPad
        textField.layer.cornerRadius = 10
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.Haruby.textBright40.cgColor
        
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
    
    // 임시 상세 내역 기록하기 뷰
    private lazy var detailInputCellView = DetailInputCell()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        addSubviews()
        configureConstraints()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    // MARK: - UI Setup
    private func addSubviews() {
        self.view.addSubview(dateStackView)
        self.view.addSubview(amountTextField)
        self.view.addSubview(detailInputButtonStackView)
        self.view.addSubview(detailInputCellView)
        
        detailInputCellView.isHidden = true
    }
    
    private func configureConstraints() {
        dateStackView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(58)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(24)
            make.height.equalTo(40)
        }
        
        amountTextField.snp.makeConstraints { make in
            make.top.equalTo(self.dateStackView.snp.bottom).offset(32)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(54)
        }
        
        detailInputButtonStackView.snp.makeConstraints { make in
            make.top.equalTo(self.amountTextField.snp.bottom).offset(10)
            make.leading.equalTo(view.safeAreaLayoutGuide).inset(28)
            make.right.equalTo(view.safeAreaLayoutGuide).inset(243)
            make.height.equalTo(40)
        }
        
        detailInputCellView.snp.makeConstraints { make in
            make.top.equalTo(self.detailInputButtonStackView.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
        }
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

        reactor.state
            .map { $0.isDetailVisible }
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] isVisible in
                guard let self = self else { return }
                self.detailInputCellView.isHidden = !isVisible
                
                let angle: CGFloat = isVisible ? .pi : 0
                UIView.animate(withDuration: 0.1) {
                    self.detailInputChevron.transform = CGAffineTransform(rotationAngle: angle)
                }
            })
            .disposed(by: disposeBag)
    }
}
