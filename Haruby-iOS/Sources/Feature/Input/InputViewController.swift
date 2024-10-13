//
//  InputViewController.swift
//  Haruby-iOS
//
//  Created by Seo-Jooyoung on 10/10/24.
//

import UIKit
import SnapKit

class InputViewController: UIViewController {
    // MARK: - Properties
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.text = "날짜"
        label.textColor = UIColor.black
        label.font = .systemFont(ofSize: 20)
        return label
    }()
    
    private lazy var datePickerButton: UIButton = {
        let button = UIButton()
        button.setTitle("2024.09.28", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20)
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
        textField.setPlaceholder(color: .gray)
        textField.textAlignment = .left
        textField.textColor = .black
        textField.borderStyle = .roundedRect
        textField.backgroundColor = .clear
        textField.layer.cornerRadius = 10.0
        textField.layer.borderWidth = 1.0
        textField.layer.borderColor = UIColor.gray.cgColor
        
        return textField
    }()
    
    private lazy var detailInputButton: UIButton = {
        let button = UIButton()
        button.setTitle("상세 내역 기록하기", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14)
        return button
    }()
    
    private lazy var detailInputChevron: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "chevron.down"), for: .normal)
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
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        addSubviews()
        configureConstraints()
    }
    
    // MARK: - UI Setup
    private func addSubviews() {
        self.view.addSubview(dateStackView)
        self.view.addSubview(amountTextField)
        self.view.addSubview(detailInputButtonStackView)
    }
    
    private func configureConstraints() {
        dateStackView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(58)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(24)
            make.height.equalTo(40)
        }
        
        amountTextField.snp.makeConstraints { make in
            make.top.equalTo(self.dateStackView.snp_bottomMargin).offset(32)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(54)
        }
        
        detailInputButtonStackView.snp.makeConstraints { make in
            make.top.equalTo(self.amountTextField.snp_bottomMargin).offset(10)
            make.left.equalTo(view.safeAreaLayoutGuide).inset(28)
            make.right.equalTo(view.safeAreaLayoutGuide).inset(243)
            make.height.equalTo(40)
        }
    }
}
