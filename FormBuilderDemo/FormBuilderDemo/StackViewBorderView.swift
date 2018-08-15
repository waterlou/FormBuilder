//
//  StackViewBorderView.swift
//  FormBuilderDemo
//
//  Created by Water Lou on 15/8/2018.
//  Copyright © 2018 Water Lou. All rights reserved.
//

import UIKit

class StackViewBorderView: UIView {

    @IBOutlet weak var stackView: UIStackView!
    
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
        
        UIColor.darkGray.setStroke()
        
        let path = UIBezierPath(roundedRect: self.bounds.insetBy(dx: 1, dy: 1), cornerRadius: 16)
        let width = self.bounds.width
        for i in stride(from: 0, to: yValues.count, by: 2) {
            let v1 = yValues[i]
            let v2 = yValues[i+1]
            let mid = (v1 + v2) / 2.0
            path.move(to: CGPoint(x: 1, y: mid))
            path.addLine(to: CGPoint(x: width-1, y: mid))
        }
        path.lineWidth = 0.5
        path.stroke()
    }

}
