//
//  DatePickerSheet.swift
//  Haruby-iOS
//
//  Created by Seo-Jooyoung on 10/15/24.
//

import UIKit
import SnapKit

final class DatePickerView: UIViewController {
    lazy var datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .inline
        picker.backgroundColor = .Haruby.white
        return picker
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    private func setupView() {
        view.backgroundColor = .Haruby.white
        
        setupSubviews()
        setupConstraints()
    }
    
    private func setupSubviews() {
        self.view.addSubview(datePicker)
    }
    
    private func setupConstraints() {
        datePicker.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(15)
            make.center.equalToSuperview()
        }
    }
}

