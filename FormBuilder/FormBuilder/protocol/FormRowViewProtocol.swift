//
//  FormRowViewProtocol.swift
//  FormBuilder
//
//  Created by Water Lou on 17/7/2018.
//  Copyright © 2018 Water Lou. All rights reserved.
//

import UIKit

public protocol FormRowViewProtocolBase: class {
    // key of the rowView
    var key: String? { get }

    // if this row view is a section header, return string or
    var isSectionHeader: Bool { get }
    
    // show error
    var errors: [Error]? { get set }
    
    // is it selectable, for tableView
    var isSelectable: Bool { get }
    
    // setup rowView
    func setup(form: BaseForm)
    
    // responder
    var isFirstResponder: Bool { get }
    var canBecomeFirstResponder: Bool { get }
    func becomeFirstResponder() -> Bool
    
    // validation
    // var valiationTexts: [String] { }
    
    // functions for binding
    func update(value: Any?)    // update value to control
    var value: Any? { get }       // get value from control
    // sometimes control value may be same type as model value, use these functions to transform data
    var formTransform: FormTransformProtocol? { get }
}

// FormRowViewProtocol restrict to UIView only
public protocol FormRowViewProtocol: FormRowViewProtocolBase where Self: UIView {
}

extension FormRowViewProtocol where Self: UIView {
    
    // properties for using FormRow in tableView
    public func cell(withIdentifier identifier: String) -> FormRowTableViewCell {
        let cell = FormRowTableViewCell(style: .default, reuseIdentifier: identifier)
        cell.contentView.addSubview(self)
        // expand view bounds to superview size
        self.translatesAutoresizingMaskIntoConstraints = false
        cell.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[subview]-0-|", options: .directionLeadingToTrailing, metrics: nil, views: ["subview": self]))
        cell.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[subview]-0-|", options: .directionLeadingToTrailing, metrics: nil, views: ["subview": self]))
        cell.formRowViewProtocol = self
        cell.separatorInset = .zero
        return cell
    }
    
    // try to cell the cell from rowView
    var cell: FormRowTableViewCell? {
        return self.superview?.superview as? FormRowTableViewCell
    }
}

extension UIView {
    
    // subview inside rowview -> RowView
    public var parentFormRowView : FormRowViewProtocol? {
        var view: UIView? = self
        while view != nil {
            if let rowView = view as? FormRowViewProtocol {
                return rowView
            }
            view = view?.superview
        }
        return nil
    }

}
