//
//  CalendarViewController.swift
//  Haruby-iOS
//
//  Created by 신승재 on 10/10/24.
//

import UIKit

import ReactorKit
import RxCocoa
import RxSwift
import SnapKit

class CalendarViewController: UIViewController, View {
    
    var disposeBag: DisposeBag = DisposeBag()
    typealias Reactor = CalendarViewReactor
    
    // MARK: - Properties
    private var numbers = Array(1...100)
    
    // MARK: - UI Component
    private lazy var monthLabel: UILabel = {
        let label = UILabel()
        label.text = "9월"
        label.font = .systemFont(ofSize: 36, weight: .semibold)
        // TODO: 색 바꾸기
        label.textColor = .white
        
        label.snp.makeConstraints { make in
            make.height.equalTo(54)
        }
        
        return label
    }()
    
    private lazy var totalHarubyValueLabel: UILabel = {
        let label = UILabel()
        label.text = "170,000원"
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        // TODO: 색 바꾸기
        label.textColor = .white
        
        label.snp.makeConstraints { make in
            make.height.equalTo(21)
        }
        
        return label
    }()
    
    private lazy var remainTotalHarubyBox: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        // TODO: 색 바꾸기
        view.layer.borderColor = UIColor.white.withAlphaComponent(0.2).cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 10
        
        let totalHarubyTitleLabel = UILabel()
        totalHarubyTitleLabel.text = "남은 총 하루비"
        totalHarubyTitleLabel.font = .systemFont(ofSize: 14, weight: .medium)
        // TODO: 색 바꾸기
        totalHarubyTitleLabel.textColor = .white
        
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
        view.backgroundColor = .white
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
            label.font = .systemFont(ofSize: 16, weight: .medium)
            label.textColor = .black
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
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(CalendarViewCell.self, forCellWithReuseIdentifier: "CalendarViewCell")
        
        return collectionView
    }()
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self

        // Do any additional setup after loading the view.
        initConstraints()
    }
    
    override func loadView() {
        title = "캘린더"
        
        let view = UIView()
        self.view = view
        // TODO: 색 바꾸기
        view.backgroundColor = UIColor(red: 78/255, green: 84/255, blue: 198/255, alpha: 1)
        
        [monthLabel, remainTotalHarubyBox, topRoundedContainer].forEach{ self.view.addSubview($0) }
    }
    
    // MARK: - Binding
    func bind(reactor: CalendarViewReactor) {
            // code
    }
    
    // MARK: - Private Methods
    private func initConstraints() {
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
    }
}

extension CalendarViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numbers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CalendarViewCell", for: indexPath) as! CalendarViewCell
        cell.configure(with: numbers[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width / 7
        return CGSize(width: width, height: 83)
    }
}
