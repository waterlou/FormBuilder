//
//  Form.swift
//  FormBuilder
//
//  Created by Water Lou on 13/7/2018.
//  Copyright © 2018 Water Lou. All rights reserved.
//

import UIKit

// syntax sugar for creating FormRowView to Form
infix operator +=: AssignmentPrecedence

public func +=(form: BaseForm, rowView: FormRowViewProtocol) {
    form.appendRow(rowView: rowView)
}

public func +=(form: BaseForm, rowViews: [FormRowViewProtocol]) {
    form.appendRows(rowViews: rowViews)
}

// automatically create RowView object by enum
public func +=(form: BaseForm, rowViewData: (String, FormRowView.BasicType)) {
    guard let viewController = form.viewController else { fatalError("viewController is null") }
    form.appendRows(rowViews: FormRowView.build(viewController, [rowViewData], options: FormRowViewOptions.default))
}

// automatically create RowView object by enum
public func +=(form: BaseForm, rowViewDatas: [(String, FormRowView.BasicType)]) {
    guard let viewController = form.viewController else { fatalError("viewController is null") }
    form.appendRows(rowViews: FormRowView.build(viewController, rowViewDatas, options: FormRowViewOptions.default))
}




open class BaseForm: NSObject {
    public weak var viewController: UIViewController?
    
    // Form is comoposed of:
    public private(set) var rowViews: [FormRowViewProtocol] = []     // views
    public var labels: [String: String]?        // key -> label string
    public var icons: [String: UIImage]?        // key -> icons
    
    public var context: Any? = nil
    
    private var containsSection = false
    var sectionsCount: [Int] = []   // count number of items in section, excluding the section header itself
    
    // reactive
    public private(set) var subscriptions: [FormSubscription] = []
    
    // subscribe a event
    public func subscribe(key: String?, event: FormSubscriptionEvent, closure: @escaping FormSubscription.Closure) {
        subscriptions.append(FormSubscription(key: key, event: event, closure: closure))
    }
    
    // signal a event
    public func signal(key: String, event: FormSubscriptionEvent) {
        guard let rowView = self.rowView(for: key) else {
            print("rowView not found for key \(key)")
            return
        }
        for subscription in self.subscriptions {
            if (subscription.key == nil || subscription.key! == key) && event == subscription.event {
                subscription.closure(self, rowView, event)
            }
        }
    }
    
    internal func setupValidator() {
        self.subscribe(key: nil, event: .valueChanged) { [unowned self] form, rowView, _ in
            guard let key = rowView.key, let value = self.valueFromControl(for: key), let validate = self.validates?[key] else { return }
            rowView.errors = self.validator.validate(value, for: key, types: validate)
        }
    }
    
    public var validator = FormValidator()      // default validator, user can override a custom one
    public var validates: [String: [FormValidator.ValidateType]]? // key -> validation rules
    
    // generic keyboard accessory view that move between fields
    lazy var inputAccessoryView: NavigationAccessoryView? = {
        let accessoryView =  NavigationAccessoryView(frame: .zero)
        accessoryView.previousButton.target = self
        accessoryView.previousButton.action = #selector(prevFirstResponder)
        accessoryView.nextButton.target = self
        accessoryView.nextButton.action = #selector(nextFirstResponder)
        accessoryView.doneButton.target = self
        accessoryView.doneButton.action = #selector(closeKeyboard)
        return accessoryView
    }()
    
    public init(_ viewController: UIViewController) {
        self.viewController = viewController
    }
    
    // append row
    open func appendRow(rowView: FormRowViewProtocol) {
        self.rowViews.append(rowView)
        if !self.containsSection && rowView.isSectionHeader {
            self.containsSection = true
        }
    }
    
    // append muliple row
    open func appendRows(rowViews: [FormRowViewProtocol]) {
        self.rowViews.append(contentsOf: rowViews)
        if !self.containsSection && rowViews.reduce(false, { c, rowView in
            return c || rowView.isSectionHeader
        }) {
            self.containsSection = true
        }
    }
    
    // key -> label
    open func label(for key: String) -> String {
        return labels?[key] ?? key
    }
    
    // key -> icon
    open func icon(for key: String) -> UIImage? {
        return icons?[key]
    }
    
    // get rowView by Key
    open func rowView(for key: String) -> FormRowViewProtocol? {
        for rowView in rowViews {
            if rowView.key == key {
                return rowView
            }
        }
        return nil
    }

    // control -> model binding
    internal func controlToModel(keys: [String]? = nil) {
        fatalError()
    }
    
    // model -> control binding
    // if key is null, will refresh all value from models to control
    internal func modelToControl(keys: [String]? = nil) {
        fatalError()
    }

    // update control value
    internal func updateControl<T>(value: T, for key: String) {
        if let rowView = self.rowView(for: key) {
            rowView.update(value: value)
        }
    }

    // get value from control
    internal func valueFromControl(for key: String) -> Any? {
        if let rowView = self.rowView(for: key) {
            return rowView.value
        }
        return nil
    }
}

extension BaseForm {
    // accessory view arrows and done
    @objc func prevFirstResponder() {
        print("prev first responder")
        if let firstResponder = self.viewController?.view.firstResponder as? FormRowViewProtocol, var index = self.rowViews.index(where: { return $0.key == firstResponder.key }) {
            index -= 1
            while index >= 0 {
                let nextRowView = self.rowViews[index]
                if nextRowView.canBecomeFirstResponder {
                    _ = nextRowView.becomeFirstResponder()
                    return
                }
                index -= 1
            }
        }
    }
    
    @objc func nextFirstResponder() {
        print("next first responder")
        if let firstResponder = self.viewController?.view.firstResponder as? FormRowViewProtocol, var index = self.rowViews.index(where: { return $0.key == firstResponder.key }) {
            index += 1
            while index < self.rowViews.count {
                let nextRowView = self.rowViews[index]
                if nextRowView.canBecomeFirstResponder {
                    _ = nextRowView.becomeFirstResponder()
                    return
                }
                index += 1
            }
        }
    }
    
    @objc func closeKeyboard() {
        let firstResponder = self.viewController?.view.firstResponder
        firstResponder?.resignFirstResponder()
    }
}

extension BaseForm {
    
    func updateSectionCountIfNeeded() {
        if sectionsCount.count == 0 {
            updateSectionCounts()
        }
    }
    
    func updateSectionCounts() {
        assert(rowViews[0].isSectionHeader == true) // first item must be section header for form with section
        var itemCount = 0
        sectionsCount = []
        var firstOne = true
        for rowView in rowViews {
            if firstOne {
                firstOne = false
                continue
            }
            if rowView.isSectionHeader {
                sectionsCount.append(itemCount)
                itemCount = 0
            }
            itemCount += 1
        }
        sectionsCount.append(itemCount - 1)
    }
    
    internal func indexForSection(section: Int) -> Int {
        var index = 0
        var currentSection = 0
        while currentSection < section {
            index += 1 + sectionsCount[currentSection]
            currentSection += 1
        }
        return index
    }
    
    var numberOfSections: Int {
        updateSectionCountIfNeeded()
        if containsSection {
            return sectionsCount.count
        }
        return 1
    }
    
    func numberOfRows(section: Int) -> Int {
        updateSectionCountIfNeeded()
        if containsSection {
            return sectionsCount[section]
        }
        return rowViews.count
    }
    
    func header(forSection section: Int) -> String? {
        if containsSection {
            updateSectionCountIfNeeded()
            let index = indexForSection(section: section)
            if let key = rowViews[index].key {
                return self.label(for: key)
            }
        }
        return nil
    }
    
    func rowView(row: Int, section: Int) -> FormRowViewProtocol? {
        if containsSection {
            updateSectionCountIfNeeded()
            let index = indexForSection(section: section)
            return rowViews[1 + row + index]
        }
        return rowViews[row]
    }
}

