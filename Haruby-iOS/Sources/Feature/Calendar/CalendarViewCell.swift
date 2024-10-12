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

class CalendarViewCell: UICollectionViewCell, View {
    var disposeBag: DisposeBag = DisposeBag()
    typealias Reactor = CalendarViewCellReactor
    
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Properties
    // MARK: - UI Components
    private let numberLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    private let topLine: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.isHidden = true
        return view
    }()
    
    // MARK: - Binding
    func bind(reactor: CalendarViewCellReactor) {
        // State
        reactor.state.map{ $0.dayNumber }
            .bind(to: numberLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.dayNumber.isEmpty }
                    .bind(to: topLine.rx.isHidden)
                    .disposed(by: disposeBag)
    }
    
    // MARK: - Private Methods
    private func setup() {
        
        
        contentView.addSubview(numberLabel)
        contentView.addSubview(topLine)
//        contentView.layer.borderColor = UIColor.black.cgColor
//        contentView.layer.borderWidth = 1
        numberLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.horizontalEdges.equalToSuperview()
        }
        
        topLine.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
        }
    }
}
