//
//  ArrowView.swift
//  PruebaGrabilityiOS_TheMovieDB
//
//  Created by Arm on 10/07/21.
//  Copyright © 2021 Arm. All rights reserved.
//

import Foundation
import UIKit

class ArrowView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initialConfig()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initialConfig()
    }
    
    let shapeLayer = CAShapeLayer()
    
    private var fillColor: UIColor = .systemBlue
    
    private var leadingEdgeWidthPercentage: Int8 = 20
    private var trailingEdgeWidthPercentage: Int8 = 20
    
    func initialConfig() {
        self.backgroundColor = .clear
        self.layer.addSublayer(self.shapeLayer)
        self.setup()
    }
    
    func setup(fillColor: UIColor? = nil,
               leadingPercentage: Int8? = nil,
               trailingPercentage: Int8? = nil) {
        
        if let fillColor = fillColor {
            self.fillColor = fillColor
        }
        
        if let leading = leadingPercentage,
            isValidPercentageRange(leading) {
            self.leadingEdgeWidthPercentage = leading
        }
        
        if let trailing = trailingPercentage,
            isValidPercentageRange(trailing) {
            self.trailingEdgeWidthPercentage = trailing
        }
    }
    
    private func changeShape() {
        self.shapeLayer.path = arrowShapePath().cgPath
        self.shapeLayer.fillColor = self.fillColor.cgColor
    }
    
    private func isValidPercentageRange(_ percentage: Int8) -> Bool {
        return 0 ... 100 ~= percentage
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.changeShape()
    }
    
    private func arrowShapePath() -> UIBezierPath {
        let rect = self.bounds.size;
        let height = rect.height
        
        let animationValue : CGFloat = 1.0
        
        let minWidth = rect.width * 0.32
        let aWidth = (rect.width / 2.0 - minWidth) * animationValue
        let width = minWidth + aWidth
        
        let h1 = height / 4.0 * animationValue
        let h2 = height / 2.0 * animationValue
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: width, y: h1))
        path.addLine(to: CGPoint(x: width, y: height - h1))
        path.addLine(to: CGPoint(x: 0.0, y: height))
        path.move(to: CGPoint(x: rect.width - width, y: h1))
        path.addLine(to: CGPoint(x: rect.width, y: h2))
        path.addLine(to: CGPoint(x: rect.width, y:  height - h2))
        path.addLine(to: CGPoint(x: rect.width - width, y:  height - h1))
        return path
    }
}
