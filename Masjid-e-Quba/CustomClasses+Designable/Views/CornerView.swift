//
//  CornerView.swift
//  Snaab
//
//  Created by Ali Waseem on 10/31/21.
//

import UIKit

@IBDesignable class CornerView: UIView {
    
    
@IBInspectable var roundTop: CGFloat = 0.0 {
        didSet {
            self.clipsToBounds = true
            self.layer.cornerRadius = roundTop
            self.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
            setNeedsLayout()
        }
    }
    
    @IBInspectable var roundBottom: CGFloat = 0.0 {
            didSet {
                self.clipsToBounds = true
                self.layer.cornerRadius = roundBottom
                self.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
                setNeedsLayout()
            }
        }
}
