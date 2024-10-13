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
    }
}
