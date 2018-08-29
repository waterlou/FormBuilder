//
//  FormValidator.swift
//  FormBuilder
//
//  Created by Water Lou on 13/7/2018.
//  Copyright © 2018 Water Lou. All rights reserved.
//

import UIKit

public protocol FormValidationErrorProtocol {
    func errorDescriptionString(form: BaseForm, key: String) -> String;
}

public enum FormValidationError: Error, FormValidationErrorProtocol, Equatable {

    case required
    case custom(string: String)
    
    public static func == (lhs: FormValidationError, rhs: FormValidationError) -> Bool {
        switch (lhs, rhs) {
        case (.required, .required):
            return true
        case let (.custom(lhsString), .custom(rhsString)):
            return lhsString == rhsString
        default:
            return false
        }
    }
    
    public func errorDescriptionString(form: BaseForm, key: String) -> String {
        switch self {
        case .required:
            return "\(form.label(for: key)) is required."
        case .custom(let string):
            return string
        }
    }
}


open class FormValidator {

    public typealias CustomValidationClosure = (_ value: Any?, _ key: String) -> String?
    
    public enum ValidateType {
        case required
        case match(regex: NSRegularExpression)
        case gt(greaterThanValue: Any)
        case lt(lessThanValue: Any)
        case isEmail
        case isCreditCard
        case isCurrency
        case isDate
        case custom(closure: CustomValidationClosure)
    }
    
    public init() {
    }
    
    
    open func validate(_ value: Any?, for key: String, types: [ValidateType]) -> [FormValidationError]? {
        var errors: [FormValidationError] = []
        types.forEach { type in
            switch type {
            case .required:
                if value == nil {
                    errors.append(.required)
                }
                else if let string = value as? String, string.trimmingCharacters(in: .whitespaces).isEmpty {
                    errors.append(.required)
                }
            case .custom(let closure):
                if let errorString = closure(value, key) {
                    errors.append(FormValidationError.custom(string: errorString))
                }
            default:
                break
            }
        }
        if errors.count == 0 {
            return nil
        }
        return errors
    }
}
