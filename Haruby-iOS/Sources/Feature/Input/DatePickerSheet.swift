//
//  DatePickerSheet.swift
//  Haruby-iOS
//
//  Created by Seo-Jooyoung on 10/15/24.
//

import UIKit
import SnapKit

class DatePickerSheet: UIViewController, UISheetPresentationControllerDelegate {
    private lazy var datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .inline
        picker.backgroundColor = .Haruby.white
        return picker
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .Haruby.white
        
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let sheet = self.sheetPresentationController {
            sheet.delegate = self
        }
    }
    
    private func setupView() {
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
    
    func presentationControllerDidAttemptToDismiss(_ presentationController: UIPresentationController) {
        self.dismiss(animated: true, completion: nil)
    }
}

