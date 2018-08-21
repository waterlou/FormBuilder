//
//  UIButtonGestureRecognizer.swift
//  FormBuilder
//
//  Created by Water Lou on 20/8/2018.
//  Copyright © 2018 Water Lou. All rights reserved.
//

import UIKit.UIGestureRecognizerSubclass

// capture button like gesture
// 1. began on touch down
// 2. cancel on other pangesture start
// 3. end on touch up
// 4. cancel on touch up at outside
// 5. change on moving between inside and outside of the view

class UIButtonGestureRecognizer: UIGestureRecognizer {
    
    public var touchInside: Bool = false
    private var detectWithPanGesture: Bool = false
    
    // https://developer.apple.com/documentation/uikit/touches_presses_and_gestures/coordinating_multiple_gesture_recognizers/preferring_one_gesture_over_another
    
    override func shouldBeRequiredToFail(by otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if otherGestureRecognizer is UIPanGestureRecognizer && !(otherGestureRecognizer is UIScreenEdgePanGestureRecognizer) {
            print(otherGestureRecognizer)
            detectWithPanGesture = true
            return true
            
        }
        return false
    }
    
    override func canPrevent(_ preventedGestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
 
    override func reset() {
        super.reset()
        detectWithPanGesture = false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        //super.touchesBegan(touches, with: event)
        if self.state == .possible && touches.count == 1 {
            touchInside = true
            self.state = .began
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        //super.touchesMoved(touches, with: event)
        if detectWithPanGesture && touches.count > 1 {
            self.state = .failed
        }
        else {
            if let view = self.view, let location = touches.first?.location(in: view) {
                let touchInside = view.bounds.contains(location)
                print(touchInside)
                if touchInside != self.touchInside {
                    self.state = .changed
                    self.touchInside = touchInside
                }
            }
            else {
                self.state = .failed
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
        //super.touchesEnded(touches, with: event)
        if touchInside {
            self.state = .recognized
        }
        else {
            self.state = .failed
        }
        self.reset()
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent) {
        self.state = .cancelled
        self.reset()
    }
    
}
