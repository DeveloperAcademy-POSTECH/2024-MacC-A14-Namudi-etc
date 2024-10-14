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

class CalculationViewController: UIViewController {
    
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
        view.font = .pretendardSemibold_24()
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
        view.font = .pretendardSemibold_36()
        view.text = "\(12000.decimal)"
        view.textColor = .white
        view.isHidden = true
        return view
    }()
    
    private lazy var bottomLabel: UILabel = {
        let view = UILabel()
        view.font = .pretendardSemibold_24()
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
    
    
    private lazy var calculationKeypad: CalculationKeypad = {
        let view = CalculationKeypad()
        return view
    }()
    
    override func loadView() {
        let backgroundView = UIView()
        backgroundView.backgroundColor = .Haruby.main
        view = backgroundView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "하루비 계산기"
        
        self.navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.white
        ]
        
        addSubviews()
        configureConstraints()
        
        bottomView.roundCorners(cornerRadius: 20, maskedCorners: [.layerMinXMinYCorner, .layerMaxXMinYCorner])
    }
    
    // MARK: - addSubviews()
    
    private func addSubviews() {
        
        view.addSubview(topStackView)
        
        [topLabel, bottomStackView].forEach { topStackView.addArrangedSubview($0) }
        
        [bottomImageView, bottomPriceLabel, bottomLabel].forEach { bottomStackView.addArrangedSubview($0)
        }

        view.addSubview(bottomView)
        bottomView.addSubview(calculationKeypad)
    }
    
    // MARK: - configureConstraints()
    
    private func configureConstraints() {
        topStackView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(32)
            make.horizontalEdges.equalToSuperview().inset(26)
        }
        
        bottomView.snp.makeConstraints { make in
            make.top.equalTo(topStackView.snp.top).inset(100)
            make.horizontalEdges.bottom.equalToSuperview()
        }
        
        calculationKeypad.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
        }
    }

    
}
