//
//  CalendarViewCellController.swift
//  Haruby-iOS
//
//  Created by 신승재 on 10/10/24.
//

import UIKit

import ReactorKit
import RxCocoa
import RxSwift
import SnapKit

final class CalendarViewCell: UICollectionViewCell, View {
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Properties
    var disposeBag = DisposeBag()
    typealias Reactor = CalendarViewCellReactor
    
    // MARK: - UI Components
    lazy private var numberLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendardMedium_12
        label.textColor = .Haruby.textBlack
        label.textAlignment = .center
        return label
    }()
    
    lazy private var todayIndicator: UIView = {
        let view = UIView()
        view.backgroundColor = .Haruby.main
        view.layer.cornerRadius = 10.5
        view.addSubview(numberLabel)
        return view
    }()
    
    lazy private var highlightView: UIView = {
        let view = UIView()
        view.backgroundColor = .Haruby.whiteDeep
        view.addSubview(todayIndicator)
        return view
    }()
    
    lazy private var harubyLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendardMedium_11
        label.textColor = .Haruby.textBlack40
        label.textAlignment = .center
        return label
    }()
    
    lazy private var redDot: UIView = {
        let view = UIView()
        view.backgroundColor = .Haruby.red
        view.layer.cornerRadius = 3
        view.clipsToBounds = true
        return view
    }()
    
    lazy private var blueDot: UIView = {
        let view = UIView()
        view.backgroundColor = .Haruby.main
        view.layer.cornerRadius = 3
        view.clipsToBounds = true
        return view
    }()
    
    lazy private var dotStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [blueDot, redDot])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 2
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    lazy private var topLine: UIView = {
        let view = UIView()
        view.backgroundColor = .Haruby.textBlack10
        view.isHidden = true
        return view
    }()
    
    // MARK: - Binding
    func bind(reactor: CalendarViewCellReactor) {
        // Action
        
        
        
        // State
        reactor.state.map{ $0.dayNumber }
                    .bind(to: numberLabel.rx.text)
                    .disposed(by: disposeBag)
        
        reactor.state.map{ $0.harubyNumber }
                    .bind(to: harubyLabel.rx.text)
                    .disposed(by: disposeBag)
        
        reactor.state.map{ $0.isPastHaruby ? .Haruby.textBlack40 : .Haruby.main }
                    .bind(to: harubyLabel.rx.textColor)
                    .disposed(by: disposeBag)
        
        
        reactor.state.map{ $0.showHiglight ? .Haruby.whiteDeep : .clear }
                    .bind(to: highlightView.rx.backgroundColor)
                    .disposed(by: disposeBag)
        
        reactor.state.map{ $0.showTodayIndicator }
                    .bind{ isToday in
                        self.numberLabel.textColor = isToday ? .Haruby.white : .Haruby.textBlack
                        self.todayIndicator.backgroundColor = isToday ? .Haruby.main : .clear
                    }.disposed(by: disposeBag)
        
        reactor.state.map{ $0.isVisible }
                    .bind{ isVisible in
                        self.numberLabel.isHidden = !isVisible
                        self.topLine.isHidden = !isVisible
                        self.dotStackView.isHidden = !isVisible
                    }.disposed(by: disposeBag)
        
        reactor.state.map{ $0.showBlueDot }
                    .bind{ show in
                        if !show {
                            self.blueDot.removeFromSuperview()
                        }
                    }.disposed(by: disposeBag)
        
        reactor.state.map{ $0.showRedDot }
                    .bind{ show in
                        if !show {
                            self.redDot.removeFromSuperview()
                        }
                    }.disposed(by: disposeBag)
    }
    
    // MARK: - setup
    private func setupViews() {
        
        addSubviews()
        setupConstraints()
    }
    
    private func addSubviews() {
        contentView.addSubview(highlightView)
        contentView.addSubview(harubyLabel)
        contentView.addSubview(dotStackView)
        contentView.addSubview(topLine)
    }
    
    private func setupConstraints() {
        blueDot.snp.makeConstraints { make in
            make.width.height.equalTo(6)
        }
        
        redDot.snp.makeConstraints { make in
            make.width.height.equalTo(6)
        }
        
        numberLabel.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(3)
            make.horizontalEdges.equalToSuperview()
        }
        
        todayIndicator.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.equalTo(42)
        }
        
        highlightView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(4)
            make.horizontalEdges.equalToSuperview()
        }
        
        harubyLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-8)
            make.horizontalEdges.equalToSuperview()
        }
        
        dotStackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        topLine.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
        }
    }
}
