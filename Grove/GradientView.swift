//
//  GradientView.swift
//  Grove
//
//  Created by Kyle Bashour on 5/3/16.
//  Copyright © 2016 Kyle Bashour. All rights reserved.
//

import UIKit

@IBDesignable class GradientView: UIView {

    @IBInspectable var startColor: UIColor = UIColor.whiteColor() {
        didSet{
            setupView()
        }
    }

    @IBInspectable var endColor: UIColor = UIColor.blackColor() {
        didSet{
            setupView()
        }
    }

    private func setupView(){

        let colors:Array = [startColor.CGColor, endColor.CGColor]

        gradientLayer?.colors = colors
//        gradientLayer?.endPoint = CGPoint(x: 0.5, y: 1)

        self.setNeedsDisplay()
    }

    var gradientLayer: CAGradientLayer? {
        return layer as? CAGradientLayer
    }

    override class func layerClass()->AnyClass{
        return CAGradientLayer.self
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
}
