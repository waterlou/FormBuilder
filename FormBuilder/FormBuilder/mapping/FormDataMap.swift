//
//  FormData.swift
//  FormBuilder
//
//  Created by Water Lou on 13/8/2018.
//  Copyright © 2018 Water Lou. All rights reserved.
//

import Foundation


public class FormDataMapping {
    
    public internal(set) var isKeyPresent = false
    public internal(set) var currentValue: Any?
    public internal(set) var currentKey: String?
    
    enum MappingType {
        case fromControl
        case toControl
    }
    let form: BaseForm
    let mappingType: MappingType
    let availableKeys: [String]?   // restrict to these keys

    init(form: BaseForm, mappingType: MappingType, availableKeys: [String]? = nil) {
        self.form = form
        self.mappingType = mappingType
        self.availableKeys = availableKeys
    }
    
    public subscript(key: String) -> FormDataMapping {
        // save key and value associated to it
        return self.subscript(key: key)
    }
    
    private func `subscript`(key: String) -> FormDataMapping {
        
        // save key and value associated to it
        currentKey = key
        
        if mappingType == .fromControl {
            if let availableKeys = availableKeys, !availableKeys.contains(key) {
                // key not found in availableKeys, skip it
                isKeyPresent = false
                currentValue = nil
                return self
            }
            let object = form.valueFromControl(for: key)
            let isNSNull = object is NSNull
            isKeyPresent = isNSNull ? true : object != nil
            currentValue = isNSNull ? nil : object
        }
        
        return self
    }
    
    public func value<T>() -> T? {
        let value = currentValue as? T
        
        // Swift 4.1 breaks Float casting from `NSNumber`. So Added extra checks for `Float` `[Float]` and `[String:Float]`
        if value == nil && T.self == Float.self {
            if let v = currentValue as? NSNumber {
                return v.floatValue as? T
            }
        } else if value == nil && T.self == [Float].self {
            if let v = currentValue as? [Double] {
                #if swift(>=4.1)
                return v.compactMap{ Float($0) } as? T
                #else
                return v.flatMap{ Float($0) } as? T
                #endif
            }
        } else if value == nil && T.self == [String:Float].self {
            if let v = currentValue as? [String:Double] {
                return v.mapValues{ Float($0) } as? T
            }
        }
        return value
    }
    
    func setValue<T>(_ value: T) {
        guard let key = currentKey else { fatalError("key not found") }
        if let availableKeys = availableKeys, !availableKeys.contains(key) { return }
        form.updateControl(value: value, for: key)
    }

}

infix operator <-

// optional
public func <- <T>(left: inout T?, right: FormDataMapping) {
    switch right.mappingType {
    case .fromControl:   // from control to variable
        if let value: T = right.value() {
            left = value
        }
    case .toControl:   // from variable to control
        right.setValue(left)
    }
}

// non-optional
public func <- <T>(left: inout T, right: FormDataMapping) {
    switch right.mappingType {
    case .fromControl:   // from control to variable
        if let value: T = right.value() {
            left = value
        }
    case .toControl:   // from variable to control
        right.setValue(left)
    }
}

