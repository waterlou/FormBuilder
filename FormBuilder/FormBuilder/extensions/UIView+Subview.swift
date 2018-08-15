//
//  UIView+Subview.swift
//  FormBuilder
//
//  Created by Water Lou on 17/7/2018.
//  Copyright © 2018 Water Lou. All rights reserved.
//

import UIKit

extension UIView {
    
    // find if the view is subview of this view
    func isSubview(of view: UIView) -> Bool {
        if self == view {
            return true
        }
        for subview in view.subviews {
            if subview.isSubview(of: self) {
                return true
            }
        }
        return false
    }

    // recursive find first responder
    var firstResponder: UIView? {
        guard !isFirstResponder else { return self }
        
        for subview in subviews {
            if let firstResponder = subview.firstResponder {
                return firstResponder
            }
        }
        
        return nil
    }
}
