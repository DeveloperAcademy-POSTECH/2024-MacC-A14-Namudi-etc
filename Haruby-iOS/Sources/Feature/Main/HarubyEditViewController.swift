//
//  HarubyEditViewController.swift
//  Haruby-iOS
//
//  Created by 신승재 on 10/12/24.
//

import UIKit
import RxSwift
import RxCocoa
import ReactorKit

class HarubyEditViewController: UIViewController, View {
    var disposeBag: DisposeBag = DisposeBag()
    typealias Reactor = HarubyEditViewReactor
    
    // MARK: - Properties
    // MARK: - UI Components
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func loadView() {
        title = "하루비 조정"
        let view = UIView()
        self.view = view
        view.backgroundColor = .systemBackground
        
        //[decreaseButton, increaseButton, valueLabel, activityIndicator].forEach { self.view.addSubview($0) }
    }
    
    // MARK: - Binding
    func bind(reactor: HarubyEditViewReactor) {
        // code
    }
    
    // MARK: - Private Methods
    

}
