//
//  InputViewController.swift
//  Haruby-iOS
//
//  Created by Seo-Jooyoung on 10/10/24.
//

import UIKit
import SnapKit

class InputViewController: UIViewController {
    // MARK: - Properties
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.text = "날짜"
        label.textColor = UIColor.black
        label.font = .systemFont(ofSize: 20)
        return label
    }()
    
    private lazy var datePickerButton: UIButton = {
        let button = UIButton()
        button.setTitle("2024.09.28", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20)
        return button
    }()
    
    private lazy var dateStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [self.dateLabel, self.datePickerButton])
        view.axis = .horizontal
        view.alignment = .fill
        view.spacing = 195
        
        return view
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        addSubviews()
        configureConstraints()
    }
    
    // MARK: - UI Setup
    private func addSubviews() {
        self.view.addSubview(dateStackView)
    }
    
    private func configureConstraints() {
        dateStackView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(58)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(24)
            make.height.equalTo(40)
        }
    }
}
