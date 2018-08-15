//
//  FormStackView.swift
//  FormBuilder
//
//  Created by Water Lou on 13/7/2018.
//  Copyright © 2018 Water Lou. All rights reserved.
//

import UIKit

public class FormStackView: UIStackView {

    public var form: BaseForm!
    var setupFinished = false
    
    public func setupForm() {
        //assert(form != nil, "Form not set in FormStackView")
        if form == nil { return }
        if setupFinished {
            return
        }
        
        // start setup stackview
        for rowView in form.rowViews {
            rowView.setup(form: form)
            self.addArrangedSubview(rowView as! UIView)
        }

        // copy all data from model to control
        form.modelToControl()
        
        setupFinished = true
    }
}
