//
//  StackViewBorderView.swift
//  FormBuilderDemo
//
//  Created by Water Lou on 15/8/2018.
//  Copyright © 2018 Water Lou. All rights reserved.
//

import UIKit

@IBDesignable class StackViewBorderView: UIView {

    @IBOutlet weak var stackView: UIStackView!

    @IBInspectable var drawBounds: Bool = true
    @IBInspectable var drawSeparator: Bool = true
    @IBInspectable var borderColor: UIColor = .darkGray
    @IBInspectable var cornerRadius: CGFloat = 12.0

    convenience init(drawBounds: Bool = true, drawSeparator: Bool = true, cornerRadius: CGFloat = 12.0) {
        self.init(frame: .zero)
        self.backgroundColor = .clear
        self.isUserInteractionEnabled = false
        self.drawBounds = drawBounds
        self.drawSeparator = drawSeparator
        self.cornerRadius = cornerRadius
    }
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // draw border for stackview
        // put all top and bottom of subviews in stackview, sort it, and then draw
        // one by one
        var yValues: [CGFloat] = []
        stackView.subviews.forEach { view in
            yValues.append(view.frame.minY)
            yValues.append(view.frame.maxY)
        }
        yValues.sort()
        // remove first and last
        yValues.removeFirst()
        yValues.removeLast()
        
        borderColor.setStroke()
        
        let inset: CGFloat
        let path: UIBezierPath
        if drawBounds {
            inset = 0.5
            path = UIBezierPath(roundedRect: self.bounds.insetBy(dx: inset, dy: inset), cornerRadius: cornerRadius)
        }
        else {
            inset = 0.0
            path = UIBezierPath()
        }
        let width = self.bounds.width
        for i in stride(from: 0, to: yValues.count, by: 2) {
            let v1 = yValues[i]
            let v2 = yValues[i+1]
            let mid = (v1 + v2) / 2.0
            path.move(to: CGPoint(x: inset, y: mid))
            path.addLine(to: CGPoint(x: width-inset, y: mid))
        }
        path.lineWidth = 0.5
        path.stroke()
    }
    
    func attach(to stackView: UIStackView) {
        guard let superview = stackView.superview else { print("stackview not added to view"); return }
        superview.addSubview(self)
        self.removeConstraints(self.constraints)    // remove all constraints
        self.translatesAutoresizingMaskIntoConstraints = false
        self.stackView = stackView
        superview.addConstraints([
            NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: stackView, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: stackView, attribute: .bottom, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: stackView, attribute: .leading, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: stackView, attribute: .trailing, multiplier: 1, constant: 0)])
    }

}
