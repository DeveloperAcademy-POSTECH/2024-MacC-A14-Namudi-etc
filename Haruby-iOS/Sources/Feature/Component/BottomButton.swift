//
//  BottomButton.swift
//  Haruby-iOS
//
//  Created by namdghyun on 10/10/24.
//

import UIKit

import SnapKit
import RxSwift
import RxCocoa

class BottomButton: UIButton {
    
    //MARK: - Properties
    let buttonTapSubject = PublishSubject<Void>()
    private let disposeBag = DisposeBag()
    
    // MARK: - UI Components
    private lazy var label: UILabel = {
        let label = UILabel()
        label.font = .pretendardSemibold_20()
        label.textColor = .Haruby.white
        label.textAlignment = .center
        return label
    }()
    
    // MARK: - Initializers
    init(title: String) {
        super.init(frame: .zero)
        label.text = title
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Setup View
    private func setupView() {
        backgroundColor = .Haruby.main
        
        setupSubviews()
        setupConstriants()
        setupBindings()
        setupKeyboardNotifications()
    }
    
    private func setupSubviews() {
        addSubview(label)
    }
    
    private func setupConstriants() {
        self.snp.makeConstraints { make in
            make.height.equalTo(108)
        }
        
        label.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(34)
            make.centerX.equalToSuperview()
        }
    }
    
    private func setupKeyboardNotifications() {
         NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
         NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
     }

     @objc private func handleKeyboardWillShow(notification: Notification) {
         guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
         let keyboardHeight = keyboardFrame.height
         
         UIView.animate(withDuration: 0.0) {
             self.snp.updateConstraints { make in
                 make.height.equalTo(52)
                 make.bottom.equalToSuperview().inset(keyboardHeight)
             }
             self.label.snp.updateConstraints { make in
                 make.top.equalToSuperview().offset(14)
             }
             self.superview?.layoutIfNeeded()
         }
     }

     @objc private func handleKeyboardWillHide(notification: Notification) {
         UIView.animate(withDuration: 0.0) {
             self.snp.updateConstraints { make in
                 make.height.equalTo(108)
                 make.bottom.equalToSuperview()
             }
             self.label.snp.updateConstraints { make in
                 make.top.equalToSuperview().offset(34)
             }
             self.superview?.layoutIfNeeded()
         }
     }

     // MARK: - Deinitializer
     deinit {
         NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
         NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
     }
    
    // MARK: - Private Methods
    private func setupBindings() {
        self.rx.tap
            .bind(to: buttonTapSubject)
            .disposed(by: disposeBag)
    }
}
