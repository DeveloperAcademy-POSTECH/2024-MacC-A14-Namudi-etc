//
//  InputTextField.swift
//  Haruby-iOS
//
//  Created by Seo-Jooyoung on 10/14/24.
//

import UIKit

class InputTextField: UIView {
    private lazy var containerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 7
        view.backgroundColor = .Haruby.whiteDeep50
        return view
    }()
    
    private lazy var textField: UITextField = {
        let textfield = UITextField()
        textfield.font = .pretendardMedium_16
        textfield.textColor = .Haruby.textBlack
        return textfield
    }()
    
    var placeholder: String? {
        didSet {
            self.textField.placeholder = placeholder
            self.textField.setPlaceholder(color: .Haruby.textBright40)
        }
    }
    
    var text: String? {
        get {
            return textField.text
        } set {
            textField.text = newValue
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
            make.verticalEdges.equalToSuperview().inset(8)
            make.horizontalEdges.equalToSuperview().inset(12)
        }
    }
}
