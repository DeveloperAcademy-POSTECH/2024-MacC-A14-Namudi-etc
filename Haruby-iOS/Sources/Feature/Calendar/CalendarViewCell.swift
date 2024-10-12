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
    
    private let numberLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
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
    
    // MARK: - Binding
    func bind(reactor: CalendarViewCellReactor) {
        // State
        reactor.state.map{ $0.dayNumber }
            .bind(to: numberLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    // MARK: - Private Methods
    private func setup() {
        contentView.addSubview(numberLabel)
        contentView.layer.borderColor = UIColor.black.cgColor
        contentView.layer.borderWidth = 1
        numberLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
