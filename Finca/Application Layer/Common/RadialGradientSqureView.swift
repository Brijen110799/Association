//
//  RadialGradientSqureView.swift
//  Finca
//
//  Created by anjali on 14/08/19.
//  Copyright © 2019 anjali. All rights reserved.
//

import Foundation
import UIKit
@IBDesignable
class RadialGradientSqureView: UIView {
    
    @IBInspectable var InsideColor: UIColor = UIColor.clear
    @IBInspectable var OutsideColor: UIColor = UIColor.clear
    
    override func draw(_ rect: CGRect) {
        layer.cornerRadius =  10
        backgroundColor = .clear
       
        let context = UIGraphicsGetCurrentContext()!
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let colors = [InsideColor.cgColor, OutsideColor.cgColor] as CFArray
        let gradient = CGGradient(colorsSpace: colorSpace, colors: colors, locations: nil)!
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        context.drawRadialGradient(gradient, startCenter: center, startRadius: 0, endCenter: center, endRadius: bounds.width/2, options: [.drawsAfterEndLocation])
    }
}
class RadialGradientSqureViewRoundCorner: UIView {
    
    @IBInspectable var StartColor: UIColor = UIColor.clear
    @IBInspectable var EndColor: UIColor = UIColor.clear
    
    override func draw(_ rect: CGRect) {
        layer.cornerRadius =  10
        backgroundColor = .clear
        layer.cornerRadius = bounds.height/2
        layer.masksToBounds = true
        let context = UIGraphicsGetCurrentContext()!
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let colors = [StartColor.cgColor, EndColor.cgColor] as CFArray
        let gradient = CGGradient(colorsSpace: colorSpace, colors: colors, locations: nil)!
//        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        context.drawLinearGradient(gradient, start: CGPoint(x: 0, y: bounds.midY), end: CGPoint(x: bounds.maxX, y: bounds.maxY), options:[.drawsAfterEndLocation] )
//        context.drawRadialGradient(gradient, startCenter: center, startRadius: 0, endCenter: center, endRadius: bounds.width/2, options: [.drawsAfterEndLocation])
    }
}
