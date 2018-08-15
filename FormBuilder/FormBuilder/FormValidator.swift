//
//  FormValidator.swift
//  FormBuilder
//
//  Created by Water Lou on 13/7/2018.
//  Copyright © 2018 Water Lou. All rights reserved.
//

import UIKit

public enum FormValidationError: Error {
    case required
    
    func descriptionString(key: String, label: String) -> String {
        switch self {
        case .required:
            return "Require field"
        }
    }
    
}

open class FormValidator {
    public enum ValidateType {
        case required
        case match(regex: NSRegularExpression)
        case gt(greaterThanValue: Any)
        case lt(lessThanValue: Any)
        case isEmail
        case isCreditCard
        case isCurrency
        case isDate
        //case passwordStrength(passwordRequirements: [PasswordRequirement])
    }
    
    func validate(_ value: Any, for key: String, types: [ValidateType]) -> [FormValidationError]? {
        return nil
    }
}
