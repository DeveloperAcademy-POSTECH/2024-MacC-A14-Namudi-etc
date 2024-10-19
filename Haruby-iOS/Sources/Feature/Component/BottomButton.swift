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
    
    private let normalHeight: CGFloat = 108
    private let compactHeight: CGFloat = 52
    private let normalLabelPostion: CGFloat = 34
    private let compactLabelPostion: CGFloat = 14
    
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
        fatalError("init(coder:) has not been implemented")
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
            make.height.equalTo(normalHeight)
        }
        
        label.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(normalLabelPostion)
            make.centerX.equalToSuperview()
        }
    }
    
    private func setupBindings() {
        self.rx.tap
            .bind(to: buttonTapSubject)
            .disposed(by: disposeBag)
        
        NotificationCenter.default.rx
            .notification(UIResponder.keyboardWillChangeFrameNotification)
            .withUnretained(self)
            .bind{ this, notification in
                self.handleKeyboardChangeFrame(notification: notification)
            }
            .disposed(by: disposeBag)
    }
}

extension BottomButton {
    // MARK: - Private Methods
    private func handleKeyboardChangeFrame(notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        guard let superview = self.superview else { return }
        let keyboardHeight = UIScreen.main.bounds.height - keyboardFrame.origin.y
        let isKeyboardShowing = keyboardHeight > 0
        
        UIView.animate(withDuration: 0) {
            self.snp.updateConstraints { make in
                make.height.equalTo(isKeyboardShowing ? self.compactHeight : self.normalHeight)
                make.bottom.equalToSuperview().inset(isKeyboardShowing ? keyboardHeight : 0)
            }
            self.label.snp.updateConstraints { make in
                make.top.equalToSuperview().offset(isKeyboardShowing ? self.compactLabelPostion : self.normalLabelPostion)
            }
            superview.layoutIfNeeded()
        }
    }
}
