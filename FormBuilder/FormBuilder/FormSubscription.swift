//
//  FormSubscription.swift
//  FormBuilder
//
//  Created by Water Lou on 14/8/2018.
//  Copyright © 2018 Water Lou. All rights reserved.
//

import Foundation

public class FormSubscription {
    
    public enum Event {
        case setup                  // going to show the row
        case becomeFirstResponder   // not implmemented
        case resignFirstResponder   // not implmemented
        
        case valueChanging
        case valueChanged
        case buttonClicked
        
        case validationStatusChanged    // status changed
    }
    
    public typealias Closure = (BaseForm, FormRowViewProtocol, Event, Any?) -> ()
    
    let key: String?
    let event: Event
    let closure: Closure
    
    public init(key: String?, event: Event, closure: @escaping Closure) {
        self.key = key
        self.event = event
        self.closure = closure
    }
}
