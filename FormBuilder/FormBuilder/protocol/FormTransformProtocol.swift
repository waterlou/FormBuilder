//
//  FormTransform.swift
//  FormBuilder
//
//  Created by Water Lou on 15/8/2018.
//  Copyright © 2018 Water Lou. All rights reserved.
//

import UIKit

public protocol FormTransformProtocol {
    //associatedtype ModelType
    //associatedtype ControlType
    
    //func convertTo(value: ModelType?) -> ControlType?
    //func convertFrom(value: ControlType?) -> ModelType?
}
/*
// convert known type to float, for slider
class FormFloatTransform<T>: FormTransformProtocol {
    typealias ModelType = T
    typealias ControlType = Float
    
    func convertTo(value: ModelType?) -> ControlType? {
        guard let value = value else { return nil }
        switch value {
        case let value as Double:
            return Float(value)
        case let value as Float:
            return value
        default:
            fatalError("Cannot convert value")
        }
    }
    
    func convertFrom(value: ControlType?) -> ModelType? {
        guard let value = value else { return nil }
    }
}
*/
class FormDoubleTransform {
    
}
