//
//  CalculationProcessView 2.swift
//  Haruby-iOS
//
//  Created by 이정동 on 10/14/24.
//


import UIKit
import SnapKit

final class CalculationProcessView: UIView {
    
    private lazy var containerStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.alignment = .center
        view.distribution = .equalSpacing
        view.spacing = 8
        return view
    }()
    
    private lazy var leftParenthesisSymbol: UILabel = {
        let view = UILabel()
        view.text = "("
        view.textColor = .Haruby.textBright
        view.font = .pretendardMedium_20()
        return view
    }()
    
    private lazy var totalHarubyStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.alignment = .center
        view.distribution = .fill
        view.spacing = 5
        view.backgroundColor = .Haruby.whiteDeep50
        view.layer.cornerRadius = 10
        return view
    }()
    
    private lazy var totalHarybyTitle: UILabel = {
        let view = UILabel()
        view.text = "남은 총 하루비"
        view.textColor = .Haruby.textBright
        view.font = .pretendardSemibold_11()
        return view
    }()
    
    private lazy var totalHaryby: UILabel = {
        let view = UILabel()
        view.text = "\(170000.decimalWithWon)"
        view.textColor = .Haruby.textBright
        view.font = .pretendardSemibold_16()
        return view
    }()
    
    private lazy var minusSymbol: UILabel = {
        let view = UILabel()
        view.text = "-"
        view.textColor = .Haruby.textBright
        view.font = .pretendardMedium_20()
        return view
    }()
    
    private lazy var estimatedPriceStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.alignment = .center
        view.distribution = .fill
        view.spacing = 5
        return view
    }()
    
    private lazy var estimatedPriceTitle: UILabel = {
        let view = UILabel()
        view.text = "지출 예정 금액"
        view.textColor = .Haruby.textBright
        view.font = .pretendardSemibold_11()
        return view
    }()
    
    private lazy var estimatedPrice: UILabel = {
        let view = UILabel()
        view.text = "\(36900.decimalWithWon)"
        view.textColor = .Haruby.textBright
        view.font = .pretendardSemibold_16()
        return view
    }()
    
    private lazy var rightParenthesisSymbol: UILabel = {
        let view = UILabel()
        view.text = ")"
        view.textColor = .Haruby.textBright
        view.font = .pretendardMedium_20()
        return view
    }()
    
    private lazy var divideSymbol: UILabel = {
        let view = UILabel()
        view.text = "÷"
        view.textColor = .Haruby.textBright
        view.font = .pretendardMedium_20()
        return view
    }()
    
    private lazy var remainingDayStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.alignment = .center
        view.distribution = .fill
        view.spacing = 5
        return view
    }()
    
    private lazy var remainingDayTitle: UILabel = {
        let view = UILabel()
        view.text = "남은 일자"
        view.textColor = .Haruby.textBright
        view.font = .pretendardSemibold_11()
        return view
    }()
    
    private lazy var remainingDay: UILabel = {
        let view = UILabel()
        view.text = "15일"
        view.textColor = .Haruby.textBright
        view.font = .pretendardSemibold_16()
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubviews()
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - addSubviews()
    
    private func addSubviews() {
        addSubview(containerStackView)
        
        [leftParenthesisSymbol, totalHarubyStackView, minusSymbol,
         estimatedPriceStackView, rightParenthesisSymbol, divideSymbol, remainingDayStackView].forEach {
            containerStackView.addArrangedSubview($0)
        }
        
        [totalHarybyTitle, totalHaryby].forEach { totalHarubyStackView.addArrangedSubview($0)
        }
        
        [estimatedPriceTitle, estimatedPrice].forEach {
            estimatedPriceStackView.addArrangedSubview($0)
        }
        
        [remainingDayTitle, remainingDay].forEach {
            remainingDayStackView.addArrangedSubview($0)
        }
    }
    
    // MARK: - configureConstraints()
    
    private func configureConstraints() {
        containerStackView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
        }
    }
}
