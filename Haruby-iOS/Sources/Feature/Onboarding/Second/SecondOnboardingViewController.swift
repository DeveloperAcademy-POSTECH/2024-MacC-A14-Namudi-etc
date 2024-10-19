//
//  SecondOnboardingViewController.swift
//  Haruby-iOS
//
//  Created by namdghyun on 10/19/24.
//

import UIKit
import ReactorKit

class SecondOnboardingViewController: UIViewController, View, CoordinatorCompatible {
    // MARK: - Properties
    weak var coordinator: OnboardingCoordinator?
    var disposeBag = DisposeBag()
    var didFinish: (() -> Void)?
    
    // MARK: - UI Components
    private lazy var image: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage.secondOnboarding
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private lazy var bottomButton: BottomButton = {
        let button = BottomButton()
        button.title = "다음으로"
        return button
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }
    
    // MARK: - Setup
    func setupView() {
        view.backgroundColor = .white
        setupSubviews()
        setupConstraints()
    }
    
    func setupSubviews() {
        view.addSubview(image)
        view.addSubview(bottomButton)
    }
    
    func setupConstraints() {
        image.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
        
        bottomButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
        }
    }
    
    // MARK: - Binding
    func bind(reactor: SecondOnboardingReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    func bindAction(reactor: SecondOnboardingReactor) {
        bottomButton.rx.tap
            .subscribe(onNext: { self.coordinator?.showThirdOnboarding() })
            .disposed(by: disposeBag)
    }
    
    func bindState(reactor: SecondOnboardingReactor) {
        
    }
}
