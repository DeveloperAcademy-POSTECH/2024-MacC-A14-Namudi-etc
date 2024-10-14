//
//  HarubyEditViewController.swift
//  Haruby-iOS
//
//  Created by 신승재 on 10/12/24.
//

import UIKit
import RxSwift
import RxCocoa
import ReactorKit
import SnapKit

final class HarubyEditViewController: UIViewController, View {
    var disposeBag: DisposeBag = DisposeBag()
    typealias Reactor = HarubyEditViewReactor
    
    // MARK: - Properties
    // MARK: - UI Components
    private lazy var harubyTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "하루비"
        label.font = .pretendardMedium_14()
        label.textColor = .Haruby.textBlack
        return label
    }()
    
    private lazy var harubyTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "36,900원"
        textField.font = .pretendardSemibold_20()
        textField.textColor = .Haruby.textBlack
        textField.setPlaceholderColor(.Haruby.textBrighter)
        
        return textField
    }()
    
    private lazy var harubyContainerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.Haruby.textBright40.cgColor
        view.addSubview(harubyTextField)
        harubyTextField.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(15)
            make.horizontalEdges.equalToSuperview().inset(14)
        }
        return view
    }()
    
    private lazy var memoTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "메모"
        label.font = .pretendardMedium_14()
        label.textColor = .Haruby.textBlack
        return label
    }()
    
    private lazy var memoTextField: UITextField = {
        let textField = UITextField()
        textField.font = .pretendardSemibold_20()
        textField.textColor = .Haruby.textBlack
        
        return textField
    }()
    
    private lazy var memoContainerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.Haruby.textBright40.cgColor
        view.addSubview(memoTextField)
        memoTextField.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(15)
            make.horizontalEdges.equalToSuperview().inset(14)
        }
        return view
    }()
    
    private lazy var memoFooterLabel: UILabel = {
        let label = UILabel()
        label.text = "(0/30)"
        label.font = .pretendardMedium_14()
        label.textColor = .Haruby.textBlack40
        return label
    }()
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupConstraints()
    }
    
    override func loadView() {
        title = "하루비 조정"
        let view = UIView()
        self.view = view
        view.backgroundColor = .systemBackground
        
        [harubyTitleLabel, harubyContainerView, memoTitleLabel, memoContainerView, memoFooterLabel].forEach { self.view.addSubview($0) }
    }
    
    // MARK: - Binding
    func bind(reactor: HarubyEditViewReactor) {
        // Action
        memoTextField.rx.text
            .orEmpty
            .distinctUntilChanged()
            .subscribe(onNext: { text in
                self.updateText(text)
            })
            .disposed(by: disposeBag)
        
        // State
        
    }
    
    // MARK: - Private Methods
    private func setupConstraints() {
        harubyTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(40)
            make.leading.equalToSuperview().offset(29)
        }
        
        harubyContainerView.snp.makeConstraints { make in
            make.top.equalTo(harubyTitleLabel.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
        
        memoTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(harubyContainerView.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(29)
        }
        
        memoContainerView.snp.makeConstraints { make in
            make.top.equalTo(memoTitleLabel.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
        
        memoFooterLabel.snp.makeConstraints { make in
            make.top.equalTo(memoContainerView.snp.bottom).offset(8)
            make.trailing.equalToSuperview().offset(-30)
        }
    }
    
    private func updateText(_ text: String) {
        if text.count > 30 {
            self.memoTextField.text = String(text.prefix(30))
        } else {
            self.memoFooterLabel.text = "(\(text.count)/30)"
        }
    }
}

