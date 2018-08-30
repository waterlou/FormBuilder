//
//  FormSubscription.swift
//  FormBuilder
//
//  Created by Water Lou on 14/8/2018.
//  Copyright © 2018 Water Lou. All rights reserved.
//

import Foundation

public enum Event {
    case setup                  // going to show the row
    case becomeFirstResponder   // not implmemented
    case resignFirstResponder   // not implmemented
    
    // control events
    case valueChanging
    case valueChanged
    case buttonClicked
    
    case validationStatusChanged    // status changed
    
    case hiddenStatusChanged
}
