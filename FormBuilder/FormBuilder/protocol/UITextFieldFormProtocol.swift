//
//  UITextFieldFormProtocol.swift
//  FormBuilder
//
//  Created by Water Lou on 8/8/2018.
//  Copyright © 2018 Water Lou. All rights reserved.
//

import UIKit

// extra interface that should be accessed by form
protocol UITextFieldFormProtocol: class {
    var error: Error? { get set }    // set error message
    var errorLabelColor: UIColor { get set }
    
}
