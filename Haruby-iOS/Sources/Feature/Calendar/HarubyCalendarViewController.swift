//
//  HarubyCalendarViewController.swift
//  Haruby-iOS
//
//  Created by namdghyun on 10/11/24.
//

import UIKit
import ReactorKit
import RxCocoa
import SnapKit

class HarubyCalendarViewController: UIViewController, View {
    typealias Reactor = HarubyCalendarReactor
    
    // MARK: UI Components
    private let calendarView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray // 실제 달력 구현을 위해 이 부분을 커스텀 달력 뷰로 교체해야 합니다.
        return view
    }()
    
    private let inputButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("지출 입력", for: .normal)
        return button
    }()
    
    private let detailButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("상세 보기", for: .normal)
        return button
    }()
    
    var disposeBag = DisposeBag()
    
    // MARK: Initializer
    init(reactor: Reactor) {
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: Setup
    private func setupUI() {
        view.backgroundColor = .white
        
        [calendarView, inputButton, detailButton].forEach {
            view.addSubview($0)
        }
        
        calendarView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(300) // 예시 높이, 실제 구현시 조정 필요
        }
        
        inputButton.snp.makeConstraints { make in
            make.top.equalTo(calendarView.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.width.equalTo(100)
            make.height.equalTo(44)
        }
        
        detailButton.snp.makeConstraints { make in
            make.top.equalTo(calendarView.snp.bottom).offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.width.equalTo(100)
            make.height.equalTo(44)
        }
    }
    
    // MARK: Binding
    func bind(reactor: HarubyCalendarReactor) {
        // Action
        inputButton.rx.tap
            .map { Reactor.Action.inputButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        detailButton.rx.tap
            .map { Reactor.Action.detailButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
}
