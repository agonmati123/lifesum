//
//  UIView+Identifier.swift
//  Lifesum
//
//  Created by Agon Mati on 2022-05-02.
//

import Foundation
import UIKit
extension UIView {
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }

    @IBInspectable var borderColor: UIColor? {
        get {
            return UIColor(cgColor: layer.borderColor ?? UIColor(red: 255, green: 255, blue: 255, alpha: 0).cgColor)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }

    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }

    func addGradient(colors: [UIColor], opacity: Float, angle: Double = 0) {
        let gradient = CAGradientLayer()
        gradient.frame = bounds
        gradient.colors = colors.map({ $0.cgColor })
        gradient.opacity = opacity
        gradient.apply(angle: angle)
        layer.insertSublayer(gradient, at: 0)
    }

    func dropShadow(shadowRadius: CGFloat = 2,
                    shadowOpacity: Float = 0.2,
                    shadowColor: UIColor = UIColor.black,
                    shadowOffset: CGSize = CGSize.zero) {
        layer.shadowColor = shadowColor.cgColor
        layer.shadowOffset = shadowOffset
        layer.shadowOpacity = shadowOpacity
        layer.shadowRadius = shadowRadius
    }
}

extension CAGradientLayer {
    func apply(angle: Double) {
        let x: Double! = angle / 360.0
        let a = pow(sinf(Float(2.0 * Double.pi * ((x + 0.75) / 2.0))), 2.0)
        let b = pow(sinf(Float(2 * Double.pi * ((x + 0.0) / 2))), 2)
        let c = pow(sinf(Float(2 * Double.pi * ((x + 0.25) / 2))), 2)
        let d = pow(sinf(Float(2 * Double.pi * ((x + 0.5) / 2))), 2)

        endPoint = CGPoint(x: CGFloat(c), y: CGFloat(d))
        startPoint = CGPoint(x: CGFloat(a), y: CGFloat(b))
    }
}
