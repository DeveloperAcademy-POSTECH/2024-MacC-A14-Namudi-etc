//
//  NavigateView.swift
//  Haruby-iOS
//
//  Created by namdghyun on 10/13/24.
//

import UIKit
import SnapKit

final class NavigationButton: UIButton {
    
    var circleLeftPadding: CGFloat = 11
    var circleRightPadding: CGFloat = 8
    
    // MARK: - Properties
    let circleView: UIView = {
        let view = UIView()
        view.backgroundColor = .Haruby.whiteDeep
        view.layer.cornerRadius = 22
        return view
    }()
    
    let symbolImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .Haruby.main
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let customTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendardSemibold_18
        label.textColor = .Haruby.main
        return label
    }()
    
    let customSubTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendardMedium_12
        label.textColor = .Haruby.textBright
        return label
    }()
    
    lazy var labelStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [customTitleLabel, customSubTitleLabel])
        stackView.axis = .vertical
        stackView.spacing = 2
        return stackView
    }()
    
    // MARK: - Initialization
    init() {
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    private func setupView() {
        backgroundColor = .white
        layer.cornerRadius = 10
        circleView.isUserInteractionEnabled = false
        labelStackView.isUserInteractionEnabled = false
        
        setupSubViews()
        setupConstraints()
    }
    
    private func setupSubViews() {
        addSubview(circleView)
        circleView.addSubview(symbolImageView)
        addSubview(labelStackView)
    }
    
    private func setupConstraints() {
        circleView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(circleLeftPadding)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(44)
        }
        
        symbolImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(30)
        }
        
        labelStackView.snp.makeConstraints { make in
            make.leading.equalTo(circleView.snp.trailing).offset(circleRightPadding)
            make.centerY.equalToSuperview()
        }
    }
    
    // MARK: - Public Methods
    func configure(circleLeftPadding: CGFloat, circleRightPadding: CGFloat) {
        circleView.snp.updateConstraints { make in
            make.leading.equalToSuperview().offset(circleLeftPadding)
        }
        
        labelStackView.snp.updateConstraints { make in
            make.leading.equalTo(circleView.snp.trailing).offset(circleRightPadding)
        }
    }
}
