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
    
    private let largeButtonheight: CGFloat = 108
    private let smallButtonheight: CGFloat = 52
    
    var title: String? {
        didSet {
            self.label.text = title
        }
    }
    
    // MARK: - UI Components
    private lazy var label: UILabel = {
        let label = UILabel()
        label.font = .pretendardSemibold_20
        label.textColor = .Haruby.white
        label.textAlignment = .center
        return label
    }()
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
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
    }
    
    private func setupSubviews() {
        addSubview(label)
    }
    
    private func setupConstriants() {
        self.snp.makeConstraints { make in
            make.height.equalTo(largeButtonheight)
        }
        
        label.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(34)
            make.centerX.equalToSuperview()
        }
    }
    
    private func setupBindings() {
        self.rx.tap
            .bind(to: buttonTapSubject)
            .disposed(by: disposeBag)
        
        NotificationCenter.default.rx
            .notification(UIResponder.keyboardWillShowNotification)
            .withUnretained(self)
            .bind{ this, notification in
                self.handleKeyboardWillShow(notification: notification)
            }
            .disposed(by: disposeBag)
        
        NotificationCenter.default.rx
            .notification(UIResponder.keyboardWillHideNotification)
            .withUnretained(self)
            .bind{ this, notification in
                self.handleKeyboardWillHide(notification: notification)
            }
            .disposed(by: disposeBag)
    }
}

extension BottomButton {
    // MARK: - Private Methods
     private func handleKeyboardWillShow(notification: Notification) {
         guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
         let keyboardHeight = keyboardFrame.height
         
         UIView.animate(withDuration: 0.0) {
             self.snp.updateConstraints { make in
                 make.height.equalTo(self.smallButtonheight)
                 make.bottom.equalToSuperview().inset(keyboardHeight)
             }
             self.label.snp.updateConstraints { make in
                 make.top.equalToSuperview().offset(14)
             }
             self.superview?.layoutIfNeeded()
         }
     }

     private func handleKeyboardWillHide(notification: Notification) {
         UIView.animate(withDuration: 0.0) {
             self.snp.updateConstraints { make in
                 make.height.equalTo(self.largeButtonheight)
                 make.bottom.equalToSuperview()
             }
             self.label.snp.updateConstraints { make in
                 make.top.equalToSuperview().offset(34)
             }
             self.superview?.layoutIfNeeded()
         }
     }
}
