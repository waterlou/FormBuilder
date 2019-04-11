//
//  FormRowViewOptions.swift
//  FormBuilder
//
//  Created by Water Lou on 14/8/2018.
//  Copyright © 2018 Water Lou. All rights reserved.
//

import Foundation

public struct FormRowViewOptions {
    
    public static var `default` = FormRowViewOptions()
    public static func setDefault(_ options: FormRowViewOptions) { FormRowViewOptions.default = options }
    public static func resetDefault() { FormRowViewOptions.default = FormRowViewOptions() }
    
    public let nibName: String?
    public let bundle: Bundle?
    
    public let titleFont: UIFont?
    public let minimumHeight: CGFloat?
    public let minimumLabelWidth: CGFloat?
    public let minimumErrorMessageHeight: CGFloat?  // set this to avoid auto resize
    public let editTextFont: UIFont?
    public let textBorderStyle: UITextField.BorderStyle?
    public let textAlignment: NSTextAlignment?
    
    public init(
        nibName: String? = nil,
        bundle: Bundle? = nil,
        titleFont: UIFont? = nil,
        minimumHeight: CGFloat? = nil,
        minimumLabelWidth: CGFloat? = nil,
        minimumErrorMessageHeight: CGFloat? = nil,
        editTextFont: UIFont? = nil,
        textBorderStyle: UITextField.BorderStyle? = nil,
        textAlignment: NSTextAlignment? = nil) {
        self.nibName = nibName
        self.bundle = bundle
        self.titleFont = titleFont
        self.minimumHeight = minimumHeight
        self.minimumLabelWidth = minimumLabelWidth
        self.minimumErrorMessageHeight = minimumErrorMessageHeight
        self.editTextFont = editTextFont
        self.textBorderStyle = textBorderStyle
        self.textAlignment = textAlignment
    }
    
}
