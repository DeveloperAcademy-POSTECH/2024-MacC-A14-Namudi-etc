//
//  ReceiptView.swift
//  Haruby-iOS
//
//  Created by namdghyun on 10/13/24.
//

import UIKit

class ReceiptView: UIView {
    private let arcRadius: CGFloat = 8
    private let sidePadding: CGFloat = 23
    
    override func layoutSubviews() {
        super.layoutSubviews()
        drawReceipt()
    }
    
    private func drawReceipt() {
        layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        
        let receiptShapeLayer = createReceiptShapeLayer()
        layer.addSublayer(receiptShapeLayer)
        
        addDottedLine(at: 45) // Top dotted line
        addDottedLine(at: frame.height - 71)
        
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
        let receiptShapePath = UIBezierPath(roundedRect: bounds, cornerRadius: 18)
        
        // 상단 좌우 아크 생성
        receiptShapePath.append(
            createArcPath(
                at: CGPoint(x: 0, y: 45),
                startAngle: .pi/2,
                endAngle: .pi*3/2,
                clockwise: false
            )
        )
        receiptShapePath.append(
            createArcPath(
                at: CGPoint(x: frame.width, y: 45),
                startAngle: .pi/2,
                endAngle: .pi*3/2,
                clockwise: true
            ).reversing()
        )
        
        // 하단 좌우 아크 생성
        receiptShapePath.append(
            createArcPath(
                at: CGPoint(x: 0, y: frame.height - 71),
                startAngle: .pi/2,
                endAngle: .pi*3/2,
                clockwise: false
            )
        )
        receiptShapePath.append(
            createArcPath(
                at: CGPoint(x: frame.width, y: frame.height - 71),
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
    
    private func addBottomSmallArcs(to             receiptShapePath: UIBezierPath) {
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
    
    private func addDottedLine(at y: CGFloat, sidePadding: CGFloat = 20) {
        let dottedLineLayer = CAShapeLayer()
        dottedLineLayer.strokeColor = UIColor.lightGray.cgColor
        dottedLineLayer.lineWidth = 1
        dottedLineLayer.lineDashPattern = [8, 8] // 8pt 선, 8pt 갭
        
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
