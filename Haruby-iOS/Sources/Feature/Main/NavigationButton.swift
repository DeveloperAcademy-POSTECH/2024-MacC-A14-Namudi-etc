//
//  NavigateView.swift
//  Haruby-iOS
//
//  Created by namdghyun on 10/13/24.
//

import UIKit
import SnapKit

final class NavigationButton: UIButton {
    // MARK: - Properties
    private let circleView: UIView = {
        let view = UIView()
        view.backgroundColor = .Haruby.whiteDeep
        view.layer.cornerRadius = 22
        return view
    }()
    
    private let symbolImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .Haruby.main
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let customTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendardSemibold_18
        label.textColor = .Haruby.main
        return label
    }()
    
    private let customSubTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendardMedium_12
        label.textColor = .Haruby.textBright
        return label
    }()
    
    private lazy var labelStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [customTitleLabel, customSubTitleLabel])
        stackView.axis = .vertical
        stackView.spacing = 2
        return stackView
    }()
    
    // MARK: - Initialization
    init(title: String, subtitle: String, symbolName: String) {
        super.init(frame: .zero)
        setupView(title: title, subtitle: subtitle, symbolName: symbolName)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    private func setupView(title: String, subtitle: String, symbolName: String) {
        backgroundColor = .white
        layer.cornerRadius = 10
        
        addSubviews()
        configureSubviews(title: title, subtitle: subtitle, symbolName: symbolName)
        setupConstraints()
    }
    
    private func addSubviews() {
        addSubview(circleView)
        circleView.addSubview(symbolImageView)
        addSubview(labelStackView)
    }
    
    private func configureSubviews(title: String, subtitle: String, symbolName: String) {
        symbolImageView.image = UIImage(systemName: symbolName)
        
        customTitleLabel.text = title
        customSubTitleLabel.text = subtitle
        
        circleView.isUserInteractionEnabled = false
        labelStackView.isUserInteractionEnabled = false
    }
    
    private func setupConstraints() {
        circleView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(11)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(44)
        }
        
        symbolImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(30)
        }
        
        labelStackView.snp.makeConstraints { make in
            make.leading.equalTo(circleView.snp.trailing).offset(8)
            make.centerY.equalToSuperview()
        }
    }
}
