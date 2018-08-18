//
//  File.swift
//  FormBuilder
//
//  Created by Water Lou on 14/8/2018.
//  Copyright © 2018 Water Lou. All rights reserved.
//

import Foundation

// Map data between this model and controls
public protocol FormDataMappable {
    mutating func mapping(map: FormDataMapping)
}

// when creating a form without any data, you can simply using this
// class to create a form
public class FormNoData: FormDataMappable {
    public func mapping(map: FormDataMapping) {}
    public init() {}
}

