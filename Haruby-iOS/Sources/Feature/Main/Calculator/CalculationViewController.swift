//
//  CalculationViewController.swift
//  Haruby-iOS
//
//  Created by 이정동 on 10/13/24.
//

import UIKit
import SnapKit
import ReactorKit
import RxSwift
import RxCocoa

final class CalculationViewController: UIViewController {
    
    private lazy var topStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 6
        view.alignment = .leading
        view.distribution = .fill
        return view
    }()
    
    private lazy var topLabel: UILabel = {
        let view = UILabel()
        view.font = .pretendardSemibold_24
        view.text = "고민 중인 지출의 금액을"
        view.numberOfLines = 2
        view.textColor = .white
        return view
    }()
    
    private lazy var bottomStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = 5
        view.alignment = .center
        view.distribution = .equalSpacing
        return view
    }()
    
    private lazy var bottomImageView: UIImageView = {
        let view = UIImageView()
        view.image = .redHaruby
        view.contentMode = .scaleAspectFit
        view.isHidden = true
        return view
    }()
    
    private lazy var bottomPriceLabel: UILabel = {
        let view = UILabel()
        view.font = .pretendardSemibold_36
        view.text = "\(12000.decimalWithWon)"
        view.textColor = .white
        view.isHidden = true
        return view
    }()
    
    private lazy var bottomLabel: UILabel = {
        let view = UILabel()
        view.font = .pretendardSemibold_24
        view.text = "입력해 주세요"
        view.numberOfLines = 2
        view.textColor = .white
        return view
    }()
    
    private lazy var bottomView: UIView = {
        let view = UIView()
        view.backgroundColor = .Haruby.white
        return view
    }()
    
    private lazy var calculationProcessView: CalculationProcessView = {
        let view = CalculationProcessView()
        return view
    }()
    
    private lazy var textField: RoundedTextField = {
        let view = RoundedTextField()
        view.placeholder = "금액을 입력해 주세요"
        return view
    }()
    
    private lazy var calculationKeypad: CalculationKeypad = {
        let view = CalculationKeypad()
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "하루비 계산기"
        view.backgroundColor = .Haruby.main
        
        setupView()
    }
    

    // MARK: - Setup View
    private func setupView() {
        setupSubviews()
        setupConstraints()
        setupNavigationBar()
    }
    
    private func setupSubviews() {
        view.addSubview(topStackView)
        
        [topLabel, bottomStackView].forEach { topStackView.addArrangedSubview($0) }
        
        [bottomImageView, bottomPriceLabel, bottomLabel].forEach { bottomStackView.addArrangedSubview($0)
        }

        view.addSubview(bottomView)
        
        bottomView.addSubview(calculationProcessView)
        bottomView.addSubview(textField)
        bottomView.addSubview(calculationKeypad)
        
        bottomView.roundCorners(cornerRadius: 20, maskedCorners: [.topLeft, .topRight])
    }
    
    private func setupConstraints() {
        topStackView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(32)
            make.horizontalEdges.equalToSuperview().inset(26)
        }
        
        bottomView.snp.makeConstraints { make in
            make.top.equalTo(topStackView.snp.top).inset(100)
            make.horizontalEdges.bottom.equalToSuperview()
        }
        
        calculationProcessView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(22)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        
        textField.snp.makeConstraints { make in
            make.bottom.equalTo(calculationKeypad.snp.top)
                .offset(-12)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        
        calculationKeypad.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
        }
    }
    
    private func setupNavigationBar() {
        self.navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.white
        ]
    }
}
