//
//  MainViewController.swift
//  initProjectWithUIKit-iOS
//
//  Created by namdghyun on 10/4/24.
//

import UIKit
import SnapKit

final class MainViewController: UIViewController {
    
    let receiptView = ReceiptView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
    }
    
    private func setupView() {
        view.backgroundColor = .systemBackground
        view.addSubview(receiptView)
    }
    
    private func setupConstraints() {
        receiptView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(142)
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(331)
        }
    }
}
