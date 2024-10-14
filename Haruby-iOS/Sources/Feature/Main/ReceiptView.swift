//
//  ReceiptView.swift
//  Haruby-iOS
//
//  Created by namdghyun on 10/13/24.
//

import UIKit

final class ReceiptView: UIView {
    // MARK: - Properties
    private let arcRadius: CGFloat = 8
    private let sidePadding: CGFloat = 15
    
    // MARK: - UI Components
    let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendard(size: 16, weight: .semiBold)
        label.textColor = .Haruby.textBlack
        return label
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendard(size: 24, weight: .semiBold)
        label.text = "-"
        label.textColor = .Haruby.textBlack
        return label
    }()
    
    private lazy var amountBox: UIView = {
        let view = UIView()
        view.backgroundColor = .Haruby.whiteDeep
        view.layer.cornerRadius = 10
        return view
    }()
    
    let amountLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendard(size: 36, weight: .bold)
        label.text = "-"
        label.textColor = .Haruby.main
        return label
    }()
    
    private let harubyImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .purpleHaruby
        imageView.contentMode = .scaleAspectFit
        imageView.snp.makeConstraints { make in
            make.width.equalTo(35)
            make.height.equalTo(30)
        }
        return imageView
    }()

    private lazy var amountStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [harubyImageView, amountLabel])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 6
        return stackView
    }()
    
    let inputButton: UIButton = {
        let button = UIButton(type: .system)
        
        var configuration = UIButton.Configuration.filled()
        configuration.baseBackgroundColor = .Haruby.main
        configuration.baseForegroundColor = .Haruby.white
        configuration.background.cornerRadius = 10
        
        configuration.title = "오늘의 지출 및 수입 입력하기"
        configuration.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = UIFont.pretendardSemibold_18
            return outgoing
        }
        
        let chevronConfig = UIImage.SymbolConfiguration(pointSize: 14, weight: .regular)
        let chevronImage = UIImage(systemName: "chevron.right", withConfiguration: chevronConfig)?.withTintColor(.white, renderingMode: .alwaysOriginal)
        configuration.image = chevronImage
        
        configuration.imagePlacement = .trailing
        configuration.imagePadding = 8
        
        button.configuration = configuration
        
        return button
    }()
    
    // MARK: - Layout
    override func layoutSubviews() {
        super.layoutSubviews()
        drawReceipt()
        setupSubviews()
    }
    
    // MARK: - Setup
    private func setupSubviews() {
        addSubview(dateLabel)
        addSubview(titleLabel)
        addSubview(amountBox)
        addSubview(amountStackView)
        addSubview(inputButton)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        dateLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(18)
            make.leading.equalToSuperview().offset(29)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(45 + 54) // 상단 점선(45) + 54
            make.centerX.equalToSuperview()
        }
        
        amountBox.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
            make.height.equalTo(53)
        }
        
        amountStackView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(amountBox).inset(10)
            make.top.bottom.equalTo(amountBox).inset(5)
        }
        
        inputButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(27)
            make.trailing.equalToSuperview().offset(-27)
            make.top.equalToSuperview().offset(frame.height - 78 + 14)
            make.bottom.equalToSuperview().offset(-25)
            make.height.equalTo(39)
        }
    }
    
    // MARK: - Methods
    private func drawReceipt() {
        layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        
        let receiptShapeLayer = createReceiptShapeLayer()
        layer.addSublayer(receiptShapeLayer)
        
        addDottedLine(at: 53)
        addDottedLine(at: frame.height - 78)
        
        addElevation()
    }
    
    private func createReceiptShapeLayer() -> CAShapeLayer {
        let receiptShapeLayer = CAShapeLayer()
        receiptShapeLayer.frame = self.bounds
        receiptShapeLayer.fillColor = UIColor.white.cgColor
        
        let receiptShapePath = createReceiptShapePath()
        receiptShapeLayer.path = receiptShapePath.cgPath
        
        return receiptShapeLayer
    }
    
    private func createReceiptShapePath() -> UIBezierPath {
        let receiptShapePath = UIBezierPath(roundedRect: bounds, cornerRadius: 10)
        
        // 상단 좌우 아크 생성
        receiptShapePath.append(
            createArcPath(
                at: CGPoint(x: 0, y: 53),
                startAngle: .pi/2,
                endAngle: .pi*3/2,
                clockwise: false
            )
        )
        receiptShapePath.append(
            createArcPath(
                at: CGPoint(x: frame.width, y: 53),
                startAngle: .pi/2,
                endAngle: .pi*3/2,
                clockwise: true
            ).reversing()
        )
        
        // 하단 좌우 아크 생성
        receiptShapePath.append(
            createArcPath(
                at: CGPoint(x: 0, y: frame.height - 78),
                startAngle: .pi/2,
                endAngle: .pi*3/2,
                clockwise: false
            )
        )
        receiptShapePath.append(
            createArcPath(
                at: CGPoint(x: frame.width, y: frame.height - 78),
                startAngle: .pi/2,
                endAngle: .pi*3/2,
                clockwise: true
            ).reversing()
        )
        
        // 하단 끝 부분 아크들 생성
        addBottomSmallArcs(to: receiptShapePath)
        
        return receiptShapePath
    }
    
    private func createArcPath(at center: CGPoint, startAngle: CGFloat, endAngle: CGFloat, clockwise: Bool) -> UIBezierPath {
        let arcPath = UIBezierPath(arcCenter: center,
                                   radius: arcRadius,
                                   startAngle: startAngle,
                                   endAngle: endAngle,
                                   clockwise: clockwise)
        arcPath.close()
        return arcPath
    }
    
    private func addBottomSmallArcs(to receiptShapePath: UIBezierPath) {
        let startX: CGFloat = sidePadding
        let endX: CGFloat = frame.width - sidePadding
        let arcSpacing: CGFloat = arcRadius * 2 + 6
        
        let availableWidth = endX - startX
        let arcCount = Int(round(availableWidth / arcSpacing))
        
        let adjustedArcSpacing = availableWidth / CGFloat(arcCount - 1)
        
        for i in 0..<arcCount {
            let centerX = startX + CGFloat(i) * adjustedArcSpacing
            let bottomArcPath = UIBezierPath(arcCenter: CGPoint(x: centerX, y: frame.height),
                                             radius: arcRadius,
                                             startAngle: CGFloat(Double.pi),
                                             endAngle: 0,
                                             clockwise: true)
            bottomArcPath.close()
            receiptShapePath.append(bottomArcPath.reversing())
        }
    }
    
    private func addDottedLine(at y: CGFloat, sidePadding: CGFloat = 8) {
        let dottedLineLayer = CAShapeLayer()
        dottedLineLayer.strokeColor = UIColor.Haruby.main.cgColor
        dottedLineLayer.lineWidth = 0.5
        dottedLineLayer.lineDashPattern = [6, 8] // 8pt 선, 8pt 갭
        
        let dottedLinePath = UIBezierPath()
        dottedLinePath.move(to: CGPoint(x: arcRadius + sidePadding, y: y))
        dottedLinePath.addLine(to: CGPoint(x: frame.width - arcRadius - sidePadding, y: y))
        
        dottedLineLayer.path = dottedLinePath.cgPath
        
        layer.addSublayer(dottedLineLayer)
    }
    
    private func addElevation() {
        layer.shadowColor = UIColor.systemGray.cgColor
        layer.shadowOpacity = 0.4
        layer.shadowRadius = 10
        layer.shadowOffset = .zero
    }
}
