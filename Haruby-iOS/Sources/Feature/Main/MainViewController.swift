//
//  MainViewController.swift
//  initProjectWithUIKit-iOS
//
//  Created by namdghyun on 10/4/24.
//

import UIKit
import SnapKit
import ReactorKit

final class MainViewController: UIViewController {
    
    private lazy var topAvgHarubyText1: UILabel = {
        let label = UILabel()
        label.textColor = .Haruby.whiteDeep50
        label.font = .pretendardMedium_14()
        label.textAlignment = .center
        label.text = "다음 월급까지의 평균 하루비는 "
        return label
    }()
    
    private lazy var topAvgHarubyText2: UILabel = {
        let label = UILabel()
        label.textColor = .Haruby.whiteDeep50
        label.font = .pretendardSemibold_14()
        label.textAlignment = .center
        label.text = "23,000원"
        return label
    }()
    
    private lazy var topAvgHarubyText3: UILabel = {
        let label = UILabel()
        label.textColor = .Haruby.whiteDeep50
        label.font = .pretendardMedium_14()
        label.textAlignment = .center
        label.text = "입니다 "
        return label
    }()
    
    private lazy var topAvgHarubyIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "info.circle")
        imageView.tintColor = .Haruby.whiteDeep50
        imageView.snp.makeConstraints { make in
            make.width.height.equalTo(17)
        }
        return imageView
    }()
    
    private lazy var topAvgHarubyStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            topAvgHarubyText1, topAvgHarubyText2, topAvgHarubyText3, topAvgHarubyIcon
        ])
        stackView.axis = .horizontal
        stackView.spacing = 0
        stackView.alignment = .center
        return stackView
    }()
    
    private lazy var receiptView: ReceiptView = {
        let view = ReceiptView(frame: .zero)
        return view
    }()
    
    private lazy var backgroundRectangle: UIView = {
        let view = UIView()
        view.backgroundColor = .Haruby.main
        return view
    }()
    
    private lazy var backgroundEllipse: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.fillColor = UIColor.Haruby.whiteDeep.cgColor
        
        let path = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: 484, height: 174))
        shapeLayer.path = path.cgPath
        
        view.layer.addSublayer(shapeLayer)
        
        return view
    }()
    
    private lazy var navigateCalculatorView = NavigationButtonView(
        title: "하루비 계산기",
        subtitle: "지금 지출이 앞으로의 하루비에 얼마나 영향을 줄까요?",
        symbolName: "plus.forwardslash.minus"
    )
    
    private lazy var navigateCalendarView = NavigationButtonView(
        title: "하루비 달력",
        subtitle: "하루비 확인 및 조정",
        symbolName: "calendar"
    )
    
    private lazy var navigateManagementView = NavigationButtonView(
        title: "하루비 관리",
        subtitle: "고정지출 및 수입 관리",
        symbolName: "wonsign"
    )
    
    private lazy var navigateStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [navigateCalendarView, navigateManagementView])
        stackView.axis = .horizontal
        stackView.spacing = 9
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
    }
    
    private func setupView() {
        view.backgroundColor = .Haruby.whiteDeep
        view.addSubview(backgroundRectangle)
        view.addSubview(backgroundEllipse)
        view.addSubview(topAvgHarubyStackView)
        view.addSubview(receiptView)
        view.addSubview(navigateCalculatorView)
        view.addSubview(navigateStackView)
    }
    
    private func setupConstraints() {
        backgroundRectangle.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.width.equalToSuperview()
            make.bottom.equalTo(backgroundEllipse.snp.centerY)
        }
        
        backgroundEllipse.snp.makeConstraints { make in
            make.centerX.equalToSuperview().offset(-0.5)
            make.top.equalToSuperview().offset(211)
            make.width.equalTo(484)
            make.height.equalTo(174)
        }
        
        topAvgHarubyStackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(receiptView.snp.top).offset(-9)
        }

        receiptView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(142)
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(331)
        }
        
        navigateCalculatorView.snp.makeConstraints { make in
            make.top.equalTo(receiptView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(106)
        }
        
        navigateStackView.snp.makeConstraints { make in
            make.top.equalTo(navigateCalculatorView.snp.bottom).offset(11)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(66)
        }
    }
}
