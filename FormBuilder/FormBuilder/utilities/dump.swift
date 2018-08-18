//
//  dump.swift
//  FormBuilder
//
//  Created by Water Lou on 17/8/2018.
//  Copyright © 2018 Water Lou. All rights reserved.
//

import Foundation

// dump class variables
public func dumpClassVariables(obj: Any) -> String {
    var results: [String] = []
    let mirror = Mirror(reflecting: obj)
    for attr in mirror.children {
        if let property_name = attr.label {
            //You can represent the results however you want here!!!
            results.append("\(property_name) : \(attr.value)")
        }
    }
    return results.joined(separator: " , ")
}
