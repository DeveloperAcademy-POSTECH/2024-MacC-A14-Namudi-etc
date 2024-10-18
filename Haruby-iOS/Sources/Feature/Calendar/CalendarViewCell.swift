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
    
    // MARK: - Properties
    var disposeBag = DisposeBag()
    typealias Reactor = CalendarViewCellReactor
    
    let tapGesture = UITapGestureRecognizer()
    
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
    
    lazy private var redXMark: UIView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "xmark")
        imageView.tintColor = .red
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()

    
    lazy private var blueDot: UIView = {
        let view = UIView()
        view.backgroundColor = .Haruby.main
        view.layer.cornerRadius = 3
        view.clipsToBounds = true
        return view
    }()
    
    var topLine: UIView = {
        let view = UIView()
        view.backgroundColor = .Haruby.textBlack10
        view.isHidden = true
        return view
    }()
    
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        reactor?.action.onNext(.viewDidLoad)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - setup
    private func setupViews() {
        
        contentView.addGestureRecognizer(tapGesture)
        
        addSubviews()
        setupConstraints()
    }
    
    private func addSubviews() {
        contentView.addSubview(highlightView)
        contentView.addSubview(blueDot)
        contentView.addSubview(harubyLabel)
        contentView.addSubview(redXMark)
        contentView.addSubview(topLine)
    }
    
    private func setupConstraints() {
        blueDot.snp.makeConstraints { make in
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
        
        redXMark.snp.makeConstraints { make in
            make.width.height.equalTo(15)
            make.bottom.equalToSuperview().offset(-8)
            make.centerX.equalToSuperview()
        }
        
        blueDot.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        topLine.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
        }
    }
    
    // MARK: - Binding
    func bind(reactor: CalendarViewCellReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    private func bindAction(reactor: CalendarViewCellReactor) {
        tapGesture.rx.event
                    .map{ _ in Reactor.Action.cellTapped }
                    .bind(to: reactor.action)
                    .disposed(by: disposeBag)
    }
    
    private func bindState(reactor: CalendarViewCellReactor) {
        
        
        reactor.state.map { $0.viewState }
            .subscribe { [unowned self] state in
                guard let state = state.element else { return }
                self.numberLabel.text = state.dayNumber
                self.harubyLabel.text = state.harubyNumber
                self.harubyLabel.textColor = state.isPastHaruby ? .Haruby.textBlack40 : .Haruby.main
                self.highlightView.backgroundColor = state.showHiglight ? .Haruby.whiteDeep : .clear
                self.numberLabel.textColor = state.showTodayIndicator ? .Haruby.white : .Haruby.textBlack
                self.todayIndicator.backgroundColor = state.showTodayIndicator ? .Haruby.main : .clear
                self.numberLabel.isHidden = !state.isVisible
                self.topLine.isHidden = !state.isVisible
                self.blueDot.isHidden = !state.showBlueDot
                self.redXMark.isHidden = !state.showRedXMark
                self.updateCornerRadius(state.highlightType)
            }
            .disposed(by: disposeBag)
    }
}

extension CalendarViewCell {
    private func updateCornerRadius(_ highlightType: CellHighlightType) {

        let cornerRadius: CGFloat = 5

        switch highlightType {
        case .leftRound:
            highlightView.roundCorners(cornerRadius: cornerRadius, maskedCorners: [.topLeft, .bottomLeft])
        case .rightRound:
            highlightView.roundCorners(cornerRadius: cornerRadius, maskedCorners: [.topRight, .bottomRight])
        case .normal:
            highlightView.layer.cornerRadius = 0
        }
        contentView.layer.masksToBounds = true
    }
}
