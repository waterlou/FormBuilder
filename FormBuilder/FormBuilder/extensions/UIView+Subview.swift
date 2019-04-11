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
    
    func parentOfClass<T>() -> T? {
        var v: UIView = self
        while let superview = v.superview {
            v = superview
            if let classed_v = v as? T {
                return classed_v
            }
        }
        return nil
    }
    
    func ensureFirstResponderInPosition(inset: UIEdgeInsets) {
        let view = self
        if let firstResponder = view.firstResponder {
            var viewableRect = view.bounds
            if #available(iOS 11.0, *) {
                viewableRect = self.safeAreaLayoutGuide.layoutFrame
            }
            viewableRect = viewableRect.inset(by: inset)
            let viewRect = firstResponder.convert(firstResponder.bounds, to: view)
            if !viewableRect.contains(viewRect) {   // blocked
                // find if there is any outer scrollview
                if let scrollView: UIScrollView = firstResponder.parentOfClass() {
                    // find parent scrollView
                    let contentOffset = scrollView.contentOffset
                    let newContentOffset = CGPoint(x: contentOffset.x, y: contentOffset.y - viewableRect.midY + viewRect.maxY)
                    scrollView.setContentOffset(newContentOffset, animated: true)
                }
            }
        }
    }

}
