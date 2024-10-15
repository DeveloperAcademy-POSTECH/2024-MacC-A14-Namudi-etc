//
//  MainHeaderView.swift
//  Haruby-iOS
//
//  Created by namdghyun on 10/15/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class MainHeaderView: UIView {
    // MARK: - Public API
    var avgHaruby: String = "-" {
        didSet {
            topAvgHarubyText2.text = avgHaruby
        }
    }
    
    // MARK: - UI Components
    private lazy var topAvgHarubyText1: UILabel = {
        let label = UILabel()
        label.textColor = .Haruby.whiteDeep50
        label.font = .pretendardMedium_14
        label.textAlignment = .center
        label.text = "다음 월급까지의 평균 하루비는 "
        return label
    }()
    
    private lazy var topAvgHarubyText2: UILabel = {
        let label = UILabel()
        label.textColor = .Haruby.whiteDeep50
        label.font = .pretendardSemibold_14
        label.textAlignment = .center
        return label
    }()
    
    private lazy var topAvgHarubyText3: UILabel = {
        let label = UILabel()
        label.textColor = .Haruby.whiteDeep50
        label.font = .pretendardMedium_14
        label.textAlignment = .center
        label.text = "입니다 "
        return label
    }()
    
    private lazy var topAvgHarubyInfoIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "info.circle")
        imageView.tintColor = .Haruby.whiteDeep50
        return imageView
    }()
    
    private lazy var topAvgHarubyStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            topAvgHarubyText1, topAvgHarubyText2, topAvgHarubyText3, topAvgHarubyInfoIcon
        ])
        stackView.axis = .horizontal
        stackView.spacing = 0
        stackView.alignment = .center
        return stackView
    }()
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup View
    private func setupView() {
        addSubview(topAvgHarubyStackView)
        
        topAvgHarubyStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(62)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        topAvgHarubyInfoIcon.snp.makeConstraints { make in
            make.width.height.equalTo(17)
        }
    }
}

// MARK: - Rx
extension Reactive where Base: MainHeaderView {
    var avgHaruby: Binder<String> {
        return Binder(self.base) { view, value in
            view.avgHaruby = value
        }
    }
}
