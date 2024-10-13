//
//  NavigateView.swift
//  Haruby-iOS
//
//  Created by namdghyun on 10/13/24.
//

import UIKit
import SnapKit

class NavigationButtonView: UIView {
    // MARK: - Properties
    private lazy var circleView: UIView = {
        let view = UIView()
        view.backgroundColor = .Haruby.whiteDeep
        view.layer.cornerRadius = 22
        return view
    }()
    
    private lazy var symbolImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .Haruby.main
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendardSemibold_18()
        label.textColor = .Haruby.main
        return label
    }()
    
    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendardMedium_12()
        label.textColor = .Haruby.textBright
        return label
    }()
    
    private lazy var labelStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        stackView.axis = .vertical
        stackView.spacing = 2
        return stackView
    }()
    
    // MARK: - Initialization
    init(title: String, subtitle: String, symbolName: String, titleFontSize: CGFloat = 16, subtitleFontSize: CGFloat = 12) {
        super.init(frame: .zero)
        setupView(title: title, subtitle: subtitle, symbolName: symbolName, titleFontSize: titleFontSize, subtitleFontSize: subtitleFontSize)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    private func setupView(title: String, subtitle: String, symbolName: String, titleFontSize: CGFloat, subtitleFontSize: CGFloat) {
        backgroundColor = .white
        layer.cornerRadius = 10
        
        addSubview(circleView)
        circleView.addSubview(symbolImageView)
        addSubview(labelStackView)
        
        symbolImageView.image = UIImage(systemName: symbolName)
        titleLabel.text = title
        subtitleLabel.text = subtitle
        
        setupConstraints()
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
