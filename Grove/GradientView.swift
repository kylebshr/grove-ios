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

    var gradientLayer: CAGradientLayer? {
        return layer as? CAGradientLayer
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }

    override class func layerClass()->AnyClass{
        return CAGradientLayer.self
    }

    private func setupView(){
        let colors:Array = [startColor.CGColor, endColor.CGColor]
        gradientLayer?.colors = colors
        self.setNeedsDisplay()
    }

}
