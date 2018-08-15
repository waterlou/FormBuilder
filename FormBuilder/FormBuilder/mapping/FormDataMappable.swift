//
//  File.swift
//  FormBuilder
//
//  Created by Water Lou on 14/8/2018.
//  Copyright © 2018 Water Lou. All rights reserved.
//

import Foundation

public protocol FormDataMappable {
    mutating func mapping(map: FormDataMapping)
}

public class FormNoData: FormDataMappable {
    public func mapping(map: FormDataMapping) {}
    public init() {}
}
