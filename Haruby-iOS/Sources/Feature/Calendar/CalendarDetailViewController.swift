//
//  CalendarDetailViewController.swift
//  Haruby-iOS
//
//  Created by namdghyun on 10/10/24.
//

import UIKit
import SnapKit

class CalendarDetailViewController: UIViewController {
    weak var coordinator: CalendarCoordinator!
    
    init(coordinator: CalendarCoordinator) {
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let label: UILabel = {
        let label = UILabel()
        label.text = "캘린더 상세 뷰"
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemCyan
        setupUI()
    }
    
    private func setupUI() {
        view.addSubview(label)
        label.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}
