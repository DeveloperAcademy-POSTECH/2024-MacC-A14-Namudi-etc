//
//  DetailInputCell.swift
//  Haruby-iOS
//
//  Created by Seo-Jooyoung on 10/14/24.
//

import UIKit

class DetailInputCell: UITableViewCell {
    
    static let cellId = "DetailInputCell"
    
    let detailNameTextField: InputTextField = {
        let textfield = InputTextField()
        textfield.placeholder = "지출 이름"
        return textfield
    }()
    
    let detailAmountTextField: InputTextField = {
        let textfield = InputTextField()
        textfield.placeholder = "지출 금액"
        return textfield
    }()
    
    private lazy var detailTextFieldStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [self.detailNameTextField, self.detailAmountTextField])
        view.axis = .horizontal
        view.spacing = 8
        view.distribution = .fillEqually
        return view
    }()
    
    let deleteButtonBackground: UIView = {
        let view = UIView()
        view.backgroundColor = .Haruby.textBright60
        view.layer.cornerRadius = 13
        return view
    }()
    
    let deleteButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "minus"), for: .normal)
        button.tintColor = .Haruby.white
        button.backgroundColor = .clear
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupSubviews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
        contentView.addSubview(deleteButtonBackground)
        deleteButtonBackground.addSubview(deleteButton)
        contentView.addSubview(detailTextFieldStackView)
    }
    
    private func setupConstraints() {
        deleteButtonBackground.snp.makeConstraints { make in
            make.width.height.equalTo(25)
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(28)
        }
        
        deleteButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(15)
        }
        
        detailTextFieldStackView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(deleteButtonBackground.snp.trailing).offset(10)
            make.trailing.equalToSuperview().inset(28)
        }
    }
}
