//
//  StatusTagView.swift
//  Finca
//
//  Created by harsh panchal on 04/08/20.
//  Copyright © 2020 anjali. All rights reserved.
//

import UIKit

class StatusTagView: UIView {
    let nibName = "StatusTagView"
    @IBOutlet weak var viewCircle: UIView!
    @IBOutlet var polygonView: UIView!
    @IBInspectable var tagBorderOpacity: CGFloat = 1
    @IBInspectable var tagBorderWidth: CGFloat = 1
    @IBInspectable var tagBorderColor: UIColor = UIColor.black
    @IBInspectable var tagFillColor : UIColor = UIColor.clear
    let shape = CAShapeLayer()

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        //custom initialization
        guard let view = loadViewFromNib() else { return }
        view.frame = self.bounds
        self.insertSubview(view, at: 0)
        polygonView = view
        self.layer.addSublayer(shape)
        drawPolylineView()
    }
    func loadViewFromNib() -> UIView? {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }

     override func layoutSublayers(of layer: CALayer) {
           super.layoutSublayers(of: layer)
           drawPolylineView()
       }

    func drawPolylineView(){
        self.viewCircle.layer.borderColor = tagBorderColor.cgColor
        self.polygonView.layer.addSublayer(shape)
        shape.opacity = Float(tagBorderOpacity)
        shape.lineWidth = tagBorderWidth
        shape.lineJoin = CAShapeLayerLineJoin.miter
        shape.fillColor = tagFillColor.cgColor
        shape.strokeColor = tagBorderColor.cgColor
        let path = UIBezierPath()

        let halfHeight = (self.frame.height/3)
        let fullheight = self.frame.height
        let halfWidth = self.frame.width - (self.frame.width - 10)
        let fullwidth = self.frame.width

        path.move(to: CGPoint(x: 0, y:(halfHeight - 3) ))

        path.addLine(to: CGPoint(x: 0, y:((halfHeight * 2) + 3)))
        path.addLine(to: CGPoint(x: halfWidth, y: fullheight))
        path.addLine(to: CGPoint(x: fullwidth, y: fullheight))
        path.addLine(to: CGPoint(x: fullwidth, y: 0))
        path.addLine(to: CGPoint(x: halfWidth, y: 0))
        path.close()
        shape.path = path.cgPath
    }
}
