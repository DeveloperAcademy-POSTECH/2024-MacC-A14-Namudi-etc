//
//  MainViewController.swift
//  initProjectWithUIKit-iOS
//
//  Created by namdghyun on 10/4/24.
//

import UIKit
import SnapKit

final class MainViewController: UIViewController {
    
    private let helloLabel: UILabel = {
        let label = UILabel()
        label.text = "Hello, Namudi.etc!"
        label.font = .pretendardSemibold_32()
        return label
    }()
    
    private let helloLabelKR: UILabel = {
        let label = UILabel()
        label.text = "안녕하세요, 나무디와나머디!"
        label.font = .pretendard(size: 24, weight: .thin)
        return label
    }()
    
    private let harubyImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = HarubyIOSImages.Image.purpleHaruby
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .whiteDeep
        view.addSubview(harubyImageView)
        view.addSubview(helloLabel)
        view.addSubview(helloLabelKR)
        
        harubyImageView.snp.makeConstraints { make in
            make.bottom.equalTo(helloLabel.snp.top)
            make.centerX.equalToSuperview()
            make.width.equalTo(55)
            make.height.equalTo(50)
        }
        
        helloLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        helloLabelKR.snp.makeConstraints { make in
            make.top.equalTo(helloLabel.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
        }
    }
}
