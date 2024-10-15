//
//  CalendarViewController.swift
//  Haruby-iOS
//
//  Created by 신승재 on 10/10/24.
//

import UIKit

import ReactorKit
import RxCocoa
import RxDataSources
import RxSwift
import SnapKit

final class CalendarViewController: UIViewController, View {
    
    var disposeBag = DisposeBag()
    typealias Reactor = CalendarViewReactor
    
    
    // MARK: - Properties
    private let cellId: String = "CalendarCell"
    private let cellHeight: CGFloat = 83
    private let horizontalPadding: CGFloat = 32
    
    // MARK: - UI Component
    private lazy var monthLabel: UILabel = {
        let label = UILabel()
        label.text = "9월"
        label.font = .pretendardSemibold_36
        label.textColor = .Haruby.white
        
        label.snp.makeConstraints { make in
            make.height.equalTo(54)
        }
        
        return label
    }()
    
    private lazy var totalHarubyValueLabel: UILabel = {
        let label = UILabel()
        label.text = "170,000원"
        label.font = .pretendardSemibold_18
        label.textColor = .Haruby.white
        
        label.snp.makeConstraints { make in
            make.height.equalTo(21)
        }
        
        return label
    }()
    
    private lazy var remainTotalHarubyBox: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.borderColor = UIColor.Haruby.white20.cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 10
        
        let totalHarubyTitleLabel = UILabel()
        totalHarubyTitleLabel.text = "남은 총 하루비"
        totalHarubyTitleLabel.font = .pretendardMedium_14
        totalHarubyTitleLabel.textColor = .Haruby.white
        
        let stackView = UIStackView(arrangedSubviews: [totalHarubyTitleLabel, totalHarubyValueLabel])
        stackView.axis = .horizontal
        stackView.spacing = 6
        stackView.alignment = .center
        stackView.distribution = .fill
        
        view.addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.verticalEdges.equalToSuperview().inset(8)
        }
        
        return view
    }()
    
    private lazy var topRoundedContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .Haruby.white
        view.layer.cornerRadius = 20
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        let stackView = UIStackView(arrangedSubviews: [weekdayHeader, collectionView])
        stackView.axis = .vertical

        view.addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(23)
            make.bottom.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        
        return view
    }()
    
    private lazy var weekdayHeader: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        
        let weekdays = ["일", "월", "화", "수", "목", "금", "토"]
        for weekday in weekdays {
            let label = UILabel()
            label.text = weekday
            label.font = .pretendardMedium_16
            label.textColor = .Haruby.textBlack
            label.textAlignment = .center
            
            label.snp.makeConstraints { make in
                make.height.equalTo(32)
            }
            
            stackView.addArrangedSubview(label)
        }
        
        view.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        return view
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        let cellWidth = (UIScreen.main.bounds.width - horizontalPadding) / 7
        layout.itemSize = CGSize(width: cellWidth, height: cellHeight)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(CalendarViewCell.self, forCellWithReuseIdentifier: self.cellId)
        
        return collectionView
    }()
    
    private lazy var warningLabel: UIView = {
       let label = UILabel()
        label.text = "아직 입력하지 않은 지출 및 수입이 있어요!"
        label.font = .pretendardMedium_12
        label.textColor = .Haruby.red
        label.textAlignment = .center
        
        let rootView = UIView()
        rootView.backgroundColor = .white
        rootView.layer.cornerRadius = 16
        
        
        let view = UIView()
        view.backgroundColor = .Haruby.red10
        view.layer.cornerRadius = 16
        
        rootView.addSubview(view)
        
        view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        view.addSubview(label)
        label.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(18)
            make.verticalEdges.equalToSuperview().inset(10)
        }
        
        return rootView
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupView()
    }
    
    
    // MARK: - Binding
    func bind(reactor: CalendarViewReactor) {
        // Action
        reactor.action.onNext(.viewDidLoad)
        
        // State
        reactor.state.map { $0.monthlySections }
            .bind(to: collectionView.rx.items(dataSource: createDataSource()))
            .disposed(by: disposeBag)
    }
    
    
    // MARK: - setup
    private func setupView() {
        title = "캘린더"
        view.backgroundColor = .Haruby.main
        
        addSubviews()
        setupConstraints()
        bindScrollEvent()
    }
    
    private func addSubviews() {
        view.addSubview(monthLabel)
        view.addSubview(remainTotalHarubyBox)
        view.addSubview(topRoundedContainer)
        view.addSubview(warningLabel)
    }
    
    
    private func setupConstraints() {
        monthLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(17)
            make.leading.equalToSuperview().offset(16)
        }
        
        remainTotalHarubyBox.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.trailing.equalToSuperview().offset(-16)
        }
        
        topRoundedContainer.snp.makeConstraints { make in
            make.top.equalTo(monthLabel.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        warningLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-6)
        }
    }
    
    
    // MARK: - Private Methods
    private func bindScrollEvent() {
        collectionView.rx.didScroll
            .subscribe(onNext: { [unowned self] in
                self.updateMonthLabel()
            })
            .disposed(by: disposeBag)
    }
    
    private func createDataSource() -> RxCollectionViewSectionedReloadDataSource<MonthlySection> {
        return RxCollectionViewSectionedReloadDataSource<MonthlySection>(
            configureCell: { dataSource, collectionView, indexPath, item in
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellId, for: indexPath) as! CalendarViewCell
                let reactor = CalendarViewCellReactor(dailyBudget: item)
                cell.reactor = reactor
                return cell
            }
        )
    }
    
    private func updateMonthLabel() {
        guard let topVisibleSection = collectionView.indexPathsForVisibleItems
                .min(by: { $0.section < $1.section })?.section,
              let sectionData = reactor?.currentState.monthlySections[topVisibleSection]
        else { return }
        
        let newMonthText = sectionData.firstDayOfMonth.formattedMonth()
        
        // 현재 텍스트와 다를 경우에만 업데이트
        if monthLabel.text != newMonthText {
            monthLabel.text = newMonthText
        }
    }
}
