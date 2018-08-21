//
//  FormStackView.swift
//  FormBuilder
//
//  Created by Water Lou on 13/7/2018.
//  Copyright © 2018 Water Lou. All rights reserved.
//

import UIKit

@IBDesignable public class FormStackView: UIStackView {

    public var form: BaseForm!
    var setupFinished = false
    
    // start add view from here, it is useful if you have subview already inside the stackview design in ib
    @IBInspectable var startIndex: Int = 0
    
    @IBInspectable dynamic var selectedTintColor: UIColor = .lightGray // UI_APPEARANCE_SELECTOR, dynamic
    
    public func setupForm() {
        //assert(form != nil, "Form not set in FormStackView")
        if form == nil { return }
        if setupFinished {
            return
        }
        
        var index = startIndex
        
        // start setup stackview
        for rowView in form.rowViews {
            rowView.setup(form: form, type: .stackView)
            //self.addArrangedSubview(rowView as! UIView)
            self.insertArrangedSubview(rowView as! UIView, at: index)
            index += 1
        }

        // copy all data from model to control
        form.modelToControl()
        
        setupFinished = true
    }
}
