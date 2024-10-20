//
//  RoundedTextField.swift
//  Haruby-iOS
//
//  Created by 이정동 on 10/14/24.
//

import UIKit
import SnapKit

final class RoundedTextField: UIView {
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.Haruby.textBright40.cgColor
    
        return view
    }()
    
    lazy var textField: UITextField = {
        let textField = UITextField()
        textField.font = .pretendardSemibold_20
        textField.textColor = .Haruby.textBlack
        textField.setPlaceholderColor(.Haruby.textBrighter)
        
        return textField
    }()
    
    var placeholder: String? {
        didSet {
            self.textField.placeholder = placeholder
        }
    }
    
    var keyboardType: UIKeyboardType = .default {
            didSet {
                self.textField.keyboardType = keyboardType
            }
        }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup View
    private func setupView() {
        setupSubviews()
        setupConstraints()
    }
    
    private func setupSubviews() {
        addSubview(containerView)
        containerView.addSubview(textField)
    }
    
    private func setupConstraints() {
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        textField.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(15)
            make.horizontalEdges.equalToSuperview().inset(14)
        }
    }
}
