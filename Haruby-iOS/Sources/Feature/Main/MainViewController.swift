//
//  MainViewController.swift
//  initProjectWithUIKit-iOS
//
//  Created by namdghyun on 10/4/24.
//

import UIKit
import SnapKit

final class MainViewController: UIViewController {
    
    private lazy var receiptView: ReceiptView = {
        let view = ReceiptView(frame: .zero)
        return view
    }()
    
    private lazy var backgroundRectangle: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBlue
        return view
    }()
    
    private lazy var backgroundEllipse: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.fillColor = UIColor.systemBackground.cgColor
        
        let path = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: 484, height: 174))
        shapeLayer.path = path.cgPath
        
        view.layer.addSublayer(shapeLayer)
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
    }
    
    private func setupView() {
        view.backgroundColor = .systemBackground
        view.addSubview(backgroundRectangle)
        view.addSubview(backgroundEllipse)
        view.addSubview(receiptView)
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

        receiptView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(142)
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(331)
        }
    }
}
