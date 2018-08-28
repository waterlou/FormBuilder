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
    
    // table section handling
    private var containsSection = false
    
    var sectionsCount: [Int] = []   // count number of items in section, excluding the section header itself
    
    // easy method for resize windows with windows popup and we can scroll, used with stackview + scrollview
    public private(set) var keyboardResizeConstraint: NSLayoutConstraint?
    var currentKeyboardHeight: CGFloat = 0

    internal class BaseFormSubscription {
        public typealias Closure = (BaseForm, FormRowViewProtocol, Event) -> ()
        
        let key: String?
        let event: Event
        let closure: Closure
        
        internal init(key: String?, event: Event, closure: @escaping Closure) {
            self.key = key
            self.event = event
            self.closure = closure
        }
    }

    // reactive
    private var baseSubscriptions: [BaseFormSubscription] = []
    
    // subscribe a event
    internal func _subscribe(key: String?, event: Event, closure: @escaping BaseFormSubscription.Closure) {
        baseSubscriptions.append(BaseFormSubscription(key: key, event: event, closure: closure))
    }
  
    // signal a event
    public func signal(rowView: FormRowViewProtocol, event: Event) {
        guard let key = rowView.key else { fatalError("key not set") }
        for subscription in self.baseSubscriptions {
            if (subscription.key == nil || subscription.key! == key) && event == subscription.event {
                subscription.closure(self, rowView, event)
            }
        }
    }
    
    private func compareErrors(_ errors1: [FormValidationErrorProtocol]?, _ errors2: [FormValidationErrorProtocol]?) -> Bool {
        if errors1 == nil && errors2 != nil {
            return false
        }
        if errors1 != nil && errors2 == nil {
            return false
        }
        // TODO: quick hack, should fix it
        if let errors1 = errors1 as? [FormValidationError], let errors2 = errors2 as? [FormValidationError] {
            return errors1 == errors2
        }
        return true // both nil
    }
    
    public func subscribeForValidator() {
        self._subscribe(key: nil, event: .valueChanging) { [unowned self] form, rowView, _ in
            guard let key = rowView.key, let validates = self.validates?[key] else { return }
            let value = self.valueFromControl(for: key)
            let newErrors = self.validator.validate(value, for: key, types: validates)
            if !self.compareErrors(newErrors, rowView.errors) {
                rowView.setErrors(form: self, errors: newErrors)
                form.signal(rowView: rowView, event: .validationStatusChanged)
            }
        }
        self._subscribe(key: nil, event: .valueChanged) { [unowned self] form, rowView, _ in
            guard let key = rowView.key, let validates = self.validates?[key] else { return }
            let value = self.valueFromControl(for: key)
            let newErrors = self.validator.validate(value, for: key, types: validates)
            if !self.compareErrors(newErrors, rowView.errors) {
                rowView.setErrors(form: self, errors: newErrors)
                form.signal(rowView: rowView, event: .validationStatusChanged)
            }
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
        super.init()
        
        self.viewController = viewController
        self.subscribeForOptions()
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
    
    // get first rowView by Key
    open func rowView(for key: String) -> FormRowViewProtocol? {
        for rowView in rowViews {
            if rowView.key == key {
                return rowView
            }
        }
        return nil
    }
    
    open func rowViews(for key: String) -> [FormRowViewProtocol] {
        return rowViews.filter { $0.key == key }
    }


    open func assignOptionValue(optionKey: String, for key: String) -> Bool {
        fatalError("not implemented")
    }

    
    // control -> model binding
    internal func controlToModel(keys: [String]? = nil) {
        fatalError("not implemented")
    }
    
    // model -> control binding
    // if key is null, will refresh all value from models to control
    open func modelToControl(keys: [String]? = nil) {
        fatalError("not implemented")
    }
    
    open func showOptions(rowView: FormRowViewProtocol, optionKeys: [String]) {
        fatalError("not implemented")
    }

    // update control value
    internal func updateControl<T>(value: T, for key: String) {
        rowViews(for: key).forEach { $0.update(value: value) }    // handle multiple controls with same key
    }

    // get value from control
    internal func valueFromControl(for key: String) -> Any? {
        if let rowView = self.rowView(for: key) {
            return rowView.value
        }
        return nil
    }
    
    private func subscribeForOptions() {
        self._subscribe(key: nil, event: .buttonClicked) { form,rowView,_ in
            if let rowView = rowView as? FormRowView {
                switch rowView.type {
                case .optionValue(let optionKey):
                    _ = form.assignOptionValue(optionKey: optionKey, for: rowView.key!)
                    form.signal(rowView: rowView, event: .valueChanged)
                case .option(let optionKeys):
                    form.showOptions(rowView: rowView, optionKeys: optionKeys)
                default:
                    break
                }
            }
        }
    }
}

extension BaseForm {
    
    // set first responder
    @discardableResult public func becomeFirstResponder(key: String? = nil) -> Bool {
        if let key = key {
            if let rowView = self.rowView(for: key) {
                return rowView.becomeFirstResponder()
            }
        }
        else {
            for rowView in self.rowViews {
                if rowView.canBecomeFirstResponder {
                    return rowView.becomeFirstResponder()
                }
            }
        }
        return false
    }
    
    // accessory view arrows and done
    @objc func prevFirstResponder() {
        print("prev first responder")
        if let firstResponder = self.viewController?.view.firstResponder as? FormRowViewProtocol, var index = self.rowViews.index(where: { return $0.key == firstResponder.key }) {
            index -= 1
            if index < 0 { index = self.rowViews.count-1 }
            while index >= 0 {
                let nextRowView = self.rowViews[index]
                if nextRowView.canBecomeFirstResponder {
                    _ = nextRowView.becomeFirstResponder()
                    return
                }
                index -= 1
                if index < 0 { index = self.rowViews.count-1 }
            }
        }
    }
    
    @objc func nextFirstResponder() {
        print("next first responder")
        if let firstResponder = self.viewController?.view.firstResponder as? FormRowViewProtocol, var index = self.rowViews.index(where: { return $0.key == firstResponder.key }) {
            index += 1
            if index >= self.rowViews.count { index = 0 }
            while index < self.rowViews.count {
                let nextRowView = self.rowViews[index]
                if nextRowView.canBecomeFirstResponder {
                    _ = nextRowView.becomeFirstResponder()
                    return
                }
                index += 1
                if index >= self.rowViews.count { index = 0 }
            }
        }
    }
    
    @objc func closeKeyboard() {
        let firstResponder = self.viewController?.view.firstResponder
        firstResponder?.resignFirstResponder()
    }
}

extension BaseForm {
    // table view section support
    
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
            else {
                itemCount += 1
            }
        }
        sectionsCount.append(itemCount)
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
        if containsSection {
            updateSectionCountIfNeeded()
            return sectionsCount.count
        }
        return 1
    }
    
    func numberOfRows(section: Int) -> Int {
        if containsSection {
            updateSectionCountIfNeeded()
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

extension BaseForm: UITextFieldDelegate, UITextViewDelegate {
    // control's delegate
    
    public func textViewDidEndEditing(_ textView: UITextView) {
        if let rowView = textView.parentFormRowView, let key = rowView.key {
            self.controlToModel(keys: [key])
            self.signal(rowView: rowView, event: .valueChanged)
        }
    }
    
    public func textViewDidChange(_ textView: UITextView) {
        if let rowView = textView.parentFormRowView, let key = rowView.key {
            self.controlToModel(keys: [key])
            self.signal(rowView: rowView, event: .valueChanging)
        }
    }
    
    @objc public func textEditingChanged(sender: UIControl) {
        if let rowView = sender.parentFormRowView, let key = rowView.key {
            self.controlToModel(keys: [key])
            self.signal(rowView: rowView, event: .valueChanging)
        }
    }

    @objc public func controlValueChanged(sender: UIControl) {
        if let rowView = sender.parentFormRowView, let key = rowView.key {
            self.controlToModel(keys: [key])
            self.signal(rowView: rowView, event: .valueChanged)
        }
    }
}

extension BaseForm {
    // handle keyboard show hide and resize scrollview, for stackView
    
    @objc func keyboardWillShow(sender: NSNotification) {
        guard let keyboardResizeConstraint = keyboardResizeConstraint else { return }
        guard let viewController = self.viewController else { return }
        let i = sender.userInfo!
        let k = (i[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.height
        keyboardResizeConstraint.constant = k
        currentKeyboardHeight = k
        //keyboardResizeConstraint.constant = k - viewController.bottomLayoutGuide.length
        let s: TimeInterval = (i[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        UIView.animate(withDuration: s) { viewController.view.layoutIfNeeded() }
        
        // ensure first responder not blocked
        self.viewController?.view.ensureFirstResponderInPosition(inset: UIEdgeInsets(top: 0, left: 0, bottom: k, right: 0))
    }
    
    @objc func keyboardWillHide(sender: NSNotification) {
        guard let keyboardResizeConstraint = keyboardResizeConstraint else { return }
        guard let viewController = self.viewController else { return }
        let info = sender.userInfo!
        let s: TimeInterval = (info[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        keyboardResizeConstraint.constant = 0
        currentKeyboardHeight = 0
        UIView.animate(withDuration: s) { viewController.view.layoutIfNeeded() }
    }
    
    public func watchKeyboardNotifications(constraint: NSLayoutConstraint) {
        self.keyboardResizeConstraint = constraint
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: Notification.Name.UIKeyboardWillShow,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: Notification.Name.UIKeyboardWillHide,
                                               object: nil)
    }
    
}
