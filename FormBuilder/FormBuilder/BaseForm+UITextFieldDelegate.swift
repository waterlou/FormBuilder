//
//  BaseForm+UITextFieldDelegate.swift
//  FormBuilder
//
//  Created by Water Lou on 14/8/2018.
//  Copyright © 2018 Water Lou. All rights reserved.
//

import UIKit

extension BaseForm: UITextFieldDelegate {
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
    
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        if let rowView = textField.parentFormRowView, let key = rowView.key {
            self.controlToModel(keys: [key])
            self.signal(key: key, event: .valueChanged)
        }
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
    
    @objc public func controlValueChanged(sender: UIControl) {
        print("control value changed")
        if let rowView = sender.parentFormRowView, let key = rowView.key {
            self.controlToModel(keys: [key])
            self.signal(key: key, event: .valueChanged)
        }
    }
}

extension BaseForm: UITextViewDelegate {
    public func textViewDidEndEditing(_ textView: UITextView) {
        if let rowView = textView.parentFormRowView, let key = rowView.key {
            self.controlToModel(keys: [key])
            self.signal(key: key, event: .valueChanged)
        }
    }
}
