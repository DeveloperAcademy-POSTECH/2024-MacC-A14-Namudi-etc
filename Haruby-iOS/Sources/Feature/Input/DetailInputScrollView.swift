//
//  DetailInputScrollView.swift
//  Haruby-iOS
//
//  Created by Seo-Jooyoung on 10/14/24.
//

import UIKit

class DetailInputScrollView: UIView {
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private lazy var addButton: UIButton = {
        let button = UIButton()
        button.setTitle("+ 지출 추가", for: .normal)
        button.setTitleColor(.Haruby.main, for: .normal)
        button.titleLabel?.font = .pretendardMedium_16
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(addDetailItem), for: .touchUpInside)
        return button
    }()
    
    private var detailItemCount: Int = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        addDetailItem()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        setupSubviews()
        setupConstraints()
    }
    
    private func setupSubviews() {
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        addSubview(addButton)
    }
    
    private func setupConstraints() {
        scrollView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(0)
            make.leading.trailing.equalToSuperview().inset(0)
        }
        
        contentView.snp.makeConstraints { make in
            make.top.equalTo(scrollView)
            make.width.equalTo(scrollView)
            make.height.equalTo(0)
            make.leading.height.equalTo(scrollView)
        }
        
        addButton.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.bottom).offset(14)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(20)
        }
    }
    
    @objc private func addDetailItem() {
        let newExpenseCell = DetailInputCell()
        contentView.addSubview(newExpenseCell)
        
        newExpenseCell.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(detailItemCount * 49)
            make.leading.trailing.equalToSuperview().inset(0)
            make.height.equalTo(40)
        }
        
        detailItemCount += 1
        
        contentView.snp.updateConstraints { make in
            make.height.equalTo(detailItemCount * 49)
        }
    }
}
