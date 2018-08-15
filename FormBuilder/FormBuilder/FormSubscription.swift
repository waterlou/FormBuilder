//
//  FormSubscription.swift
//  FormBuilder
//
//  Created by Water Lou on 14/8/2018.
//  Copyright © 2018 Water Lou. All rights reserved.
//

import Foundation

public enum FormSubscriptionEvent {
    case setup                 // going to show the row
    case becomeFirstResponder
    case resignFirstResponder

    case valueChanging
    case valueChanged
    case buttonClicked

    case validationStatusChanged    // status changed
}

public class FormSubscription {
    public typealias Closure = (BaseForm, FormRowViewProtocol, FormSubscriptionEvent) -> ()
    
    let key: String?
    let event: FormSubscriptionEvent
    let closure: Closure
    
    public init(key: String?, event: FormSubscriptionEvent, closure: @escaping Closure) {
        self.key = key
        self.event = event
        self.closure = closure
    }
}
