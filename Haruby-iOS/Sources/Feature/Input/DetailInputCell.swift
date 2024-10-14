//
//  DetailInputCell.swift
//  Haruby-iOS
//
//  Created by Seo-Jooyoung on 10/14/24.
//

import UIKit

class DetailInputCell: UITableViewCell {
    
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
        view.layer.cornerRadius = 15
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
        // deleteButtonBackground의 크기 설정 및 위치
        deleteButtonBackground.snp.makeConstraints { make in
            make.width.height.equalTo(30) // 원형 배경이 되도록 크기 설정
            make.centerY.equalToSuperview() // 세로 방향 중앙에 배치
            make.leading.equalToSuperview().offset(28) // 좌측에서 28만큼 띄워 배치
        }
        
        // deleteButton을 deleteButtonBackground 중앙에 배치
        deleteButton.snp.makeConstraints { make in
            make.center.equalToSuperview() // deleteButton이 배경의 중앙에 위치하도록
            make.width.height.equalTo(25) // deleteButton 크기 설정
        }
        
        // detailTextFieldStackView constraints
        detailTextFieldStackView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(deleteButtonBackground.snp.trailing).offset(10)
            make.trailing.equalToSuperview().inset(28)
        }
    }
}
