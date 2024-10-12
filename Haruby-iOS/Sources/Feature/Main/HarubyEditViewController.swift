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

class HarubyEditViewController: UIViewController, View {
    var disposeBag: DisposeBag = DisposeBag()
    typealias Reactor = HarubyEditViewReactor
    
    // MARK: - Properties
    // MARK: - UI Components
    private lazy var harubyTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "하루비"
        label.font = .systemFont(ofSize: 14, weight: .medium)
        return label
    }()
    
    private lazy var harubyTextField: UIView = {
        let textField = UITextField()
        textField.placeholder = "36,900원"
        textField.font = .systemFont(ofSize: 20, weight: .semibold)
        
        let view = UIView()
        
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.gray.cgColor
        
        view.addSubview(textField)
        textField.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(15)
            make.horizontalEdges.equalToSuperview().inset(14)
        }
        
        return view
    }()
    
    private lazy var memoTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "메모"
        label.font = .systemFont(ofSize: 14, weight: .medium)
        return label
    }()
    
    private lazy var memoTextField: UIView = {
        let textField = UITextField()
        textField.font = .systemFont(ofSize: 20, weight: .semibold)
        
        let view = UIView()
        
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.gray.cgColor
        
        view.addSubview(textField)
        textField.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(15)
            make.horizontalEdges.equalToSuperview().inset(14)
        }
        
        return view
    }()
    
    private lazy var memoFooterLabel: UILabel = {
        let label = UILabel()
        label.text = "(0/30)"
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .lightGray
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
        
        [harubyTitleLabel, harubyTextField, memoTitleLabel, memoTextField, memoFooterLabel].forEach { self.view.addSubview($0) }
    }
    
    // MARK: - Binding
    func bind(reactor: HarubyEditViewReactor) {
        // code
    }
    
    // MARK: - Private Methods
    private func setupConstraints() {
        harubyTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(40)
            make.leading.equalToSuperview().offset(29)
        }
        
        harubyTextField.snp.makeConstraints { make in
            make.top.equalTo(harubyTitleLabel.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
        
        memoTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(harubyTextField.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(29)
        }
        
        memoTextField.snp.makeConstraints { make in
            make.top.equalTo(memoTitleLabel.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
        
        memoFooterLabel.snp.makeConstraints { make in
            make.top.equalTo(memoTextField.snp.bottom).offset(8)
            make.trailing.equalToSuperview().offset(-30)
        }
    }

}

