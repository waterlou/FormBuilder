//
//  FormRowViewOptions.swift
//  FormBuilder
//
//  Created by Water Lou on 14/8/2018.
//  Copyright © 2018 Water Lou. All rights reserved.
//

import Foundation

public struct FormRowViewOptions {
    static var `default` = FormRowViewOptions()
    public static func setDefault(_ options: FormRowViewOptions) { FormRowViewOptions.default = options }
    
    public let nibName: String?
    public let bundle: Bundle?
    
    public let minimumHeight: CGFloat?
    public let minimumLabelWidth: CGFloat?
    
    public init(nibName: String? = nil,
    bundle: Bundle? = nil,
    minimumHeight: CGFloat? = nil,
    minimumLabelWidth: CGFloat? = nil) {
        self.nibName = nibName
        self.bundle = bundle
        self.minimumHeight = minimumHeight
        self.minimumLabelWidth = minimumLabelWidth
    }
}
