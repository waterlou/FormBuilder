//
//  Row.swift
//  FormBuilder
//
//  Created by Water Lou on 13/7/2018.
//  Copyright © 2018 Water Lou. All rights reserved.
//

import UIKit

open class FormRowView : UIView, FormRowViewProtocol {
    
    // required features
    /*
        Text Only
        - button
        Text and text
        - no action
        - options
        - date
        Text and Field
     
     */
    public enum BasicType {
        public enum EditTextType {
            case text       // normal text
            case phone      // phone number
            case email      // email address
            case password   // password
            case integer    // integer number
            case number     // double
            case currency(prefix: String)   // double currency
        }
        
        case sectionHeader
        case simpleText // need refine, simple text with selection
        case option(keys: [String]) // <-- need finish this
        case editText(type: EditTextType)   // need refine
        case uiSwitch       // DONE
        case slider(min: Float, max: Float) // DONE
        case segmentedControl(keys: [String])    // DONE
        case textView   // DONE
        case button // DONE
        case optionValue(key: String)
        
        enum FormBuilderXibIndex: Int {
            case label = 0
            case labelAndOption = 1
            case button = 2
            case textField = 3
            case uiSwitch = 4
            case slider = 5
            case segmentedControl = 6
            case textView = 7
        }
        
        var xibIndex: FormBuilderXibIndex {
            switch self {
            case .sectionHeader, .simpleText:
                return .label
            case .option, .optionValue:
                return .labelAndOption
            case .button:
                return .button
            case .editText:
                return .textField
            case .uiSwitch:
                return .uiSwitch
            case .slider:
                return .slider
            case .segmentedControl:
                return .segmentedControl
            case .textView:
                return .textView
            }
        }
    }

    // FormRowViewProtocol
    // row key
    open var key: String = ""
    
    open var isSectionHeader: Bool {
        if case .sectionHeader = type { return true }
        return false
    }
    
    open var isSelectable: Bool {
        switch type {
        case .button, .optionValue, .option:
            return true
        default:
            return false
        }
    }
    
    // if false, will not hide the error label if no error
    var hideErrorLabelWithNoError = true
    public var errors: [FormValidationErrorProtocol]?
    open func setErrors(form: BaseForm, errors: [FormValidationErrorProtocol]?) {
        self.errors = errors
        if let errorLabel = self.errorLabel {
            if let errors = errors {
                if hideErrorLabelWithNoError {
                    errorLabel.isHidden = false
                }
                errorLabel.text = (errors.map { $0.errorDescriptionString(form: form, key: self.key) }).joined(separator: "\n")
            }
            else {
                if hideErrorLabelWithNoError {
                    errorLabel.isHidden = true
                }
                errorLabel.text = nil
            }
        }
    }
    
    public private(set) var type: BasicType = .simpleText
    open var formTransform: FormTransformProtocol? = nil
    var auxiliaryLabel: String?
    var optionKeyLabels: [String: String]?  // store options label used in set values
    
    // default components in view that base class will handle it
    @IBOutlet open var iconImageView: UIImageView?
    @IBOutlet open var titleLabel: UILabel?
    @IBOutlet open var descriptionLabel: UILabel?
    // all kinds of generic controls in iOS
    @IBOutlet open var editTextField: UITextField?
    @IBOutlet open var uiSwitch: UISwitch?
    @IBOutlet open var segmentedControl: UISegmentedControl?
    @IBOutlet open var slider: UISlider?
    @IBOutlet open var stepper: UIStepper?
    @IBOutlet open var textView: UITextView?
    @IBOutlet open var errorLabel: UILabel?
    
    // tranform from type to view
    internal class func rowView(_ owner: Any, key: String, type: BasicType, options: FormRowViewOptions? = nil) -> FormRowView {
        let bundle = options?.bundle ?? Bundle(for: FormRowView.self)
        let nib = UINib(nibName: options?.nibName ?? "FormBuilderBasic", bundle: bundle)
        let view = nib.instantiate(withOwner: owner)[type.xibIndex.rawValue] as! FormRowView
        view.key = key
        view.type = type

        if let titleFont = options?.titleFont {
            view.titleLabel?.font = titleFont
        }
        
        if let editTextFont = options?.editTextFont {
            view.editTextField?.font = editTextFont
        }
        
        if let textBorderStyle = options?.textBorderStyle {
            view.editTextField?.borderStyle = textBorderStyle
        }
        
        if let textAlignment = options?.textAlignment {
            view.editTextField?.textAlignment = textAlignment
        }
        
        // hide error by default
        view.errorLabel?.isHidden = true
        
        // add some constraints
        if let minimumHeight = options?.minimumHeight {
            // set minimum height of each row height
            let minimumHeightConstraint = NSLayoutConstraint(item: view, attribute: .height, relatedBy: .greaterThanOrEqual, toItem: nil, attribute: .notAnAttribute, multiplier: 0.0, constant: minimumHeight)
            minimumHeightConstraint.priority = .required
            view.addConstraint(minimumHeightConstraint)
        }
        
        if let titleLabel = view.titleLabel, let minimumLabelWidth = options?.minimumLabelWidth {
            // set minimum label width, can align control
            let minimumWidthConstraint = NSLayoutConstraint(item: titleLabel, attribute: .width, relatedBy: .greaterThanOrEqual, toItem: nil, attribute: .notAnAttribute, multiplier: 0.0, constant: minimumLabelWidth)
            titleLabel.addConstraint(minimumWidthConstraint)
        }
        if let errorLabel = view.errorLabel, let minimumErrorMessageHeight = options?.minimumErrorMessageHeight {
            let minimumHeightConstraint = NSLayoutConstraint(item: errorLabel, attribute: .height, relatedBy: .greaterThanOrEqual, toItem: nil, attribute: .notAnAttribute, multiplier: 0.0, constant: minimumErrorMessageHeight)
            errorLabel.addConstraint(minimumHeightConstraint)
            errorLabel.isHidden = false // if having minimum height, always show the error label
            errorLabel.text = nil
            view.hideErrorLabelWithNoError = false
        }
        return view
    }
    
    // types -> views
    public class func build(_ owner: Any, _ viewTypePairs: [(String, BasicType)], options: FormRowViewOptions? = nil, nibName: String? = nil, bundle: Bundle? = nil) -> [FormRowView] {
        var rowViews = [FormRowView]()
        for (key, viewType) in viewTypePairs {
            let rowView = self.rowView(owner, key: key, type: viewType, options: options)
            rowViews.append(rowView)
        }
        return rowViews
    }

    
    ////////////////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////////

    
    // use the row view to capture first responder, that will be easier to switch focus
    open override var isFirstResponder: Bool {
        return editTextField?.isFirstResponder ?? textView?.isFirstResponder ?? false
    }
    
    open override var canBecomeFirstResponder: Bool {
        return editTextField != nil || textView != nil
    }
    
    open override func becomeFirstResponder() -> Bool {
        return editTextField?.becomeFirstResponder() ?? textView?.becomeFirstResponder() ?? false
    }
    
    open override func resignFirstResponder() -> Bool {
        return editTextField?.resignFirstResponder() ?? textView?.resignFirstResponder() ?? true
    }
    
    
    ////////////////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////////
    
    
    // setup control before show up
    open func setup(form: BaseForm, type setupType: FormRowSetupType) {
        assert(key.count>0, "key not set")
        
        // you can setup label, icon
        let title: String?
        let iconImage: UIImage?
        if case .optionValue(let optionKey) = type {
            title = form.label(for: optionKey)
            iconImage = form.icon(for: optionKey)
        }
        else {
            title = form.label(for: key)
            iconImage = form.icon(for: key)
        }
        // store that may need it when set value
        self.auxiliaryLabel = form.auxiliaryLabel(for: key)
        
        // set title and icon
        titleLabel?.text = title
        if let iconImageView = iconImageView {
            if let iconImage = iconImage {
                iconImageView.image = iconImage
                iconImageView.isHidden = false
            }
            else {
                iconImageView.image = nil
                iconImageView.isHidden = true
            }
        }
        if let formTextField = editTextField as? UITextFieldFormProtocol {
            // if textfield conform to protocol, try to set icon and title
            formTextField.icon = form.icon(for: key)
            formTextField.title = title
        }
        
        // setup controls
        if let editTextField = editTextField, case .editText(let editType) = type {
            switch editType {
            case .currency:
                editTextField.keyboardType = .decimalPad
            case .phone:
                editTextField.keyboardType = .phonePad
            case .number, .integer:
                editTextField.keyboardType = .numberPad
            case .text:
                editTextField.keyboardType = .default
            case .password:
                editTextField.keyboardType = .default
                editTextField.isSecureTextEntry = true
            case .email:
                editTextField.keyboardType = .emailAddress
            }
            
            if let auxiliaryLabel = auxiliaryLabel {
                editTextField.placeholder = auxiliaryLabel
            }
            
            editTextField.addTarget(form, action: #selector(BaseForm.textEditingChanged(sender:)), for: .editingChanged)
            editTextField.addTarget(form, action: #selector(BaseForm.textEditingDidBegin(sender:)), for: .editingDidBegin)
            editTextField.addTarget(form, action: #selector(BaseForm.textEditingDidEnd(sender:)), for: .editingDidEnd)
            editTextField.inputAccessoryView = form.inputAccessoryView  // switching field
        }
        if let uiSwitch = uiSwitch {
            uiSwitch.addTarget(form, action: #selector(BaseForm.controlValueChanged(sender:)), for: .valueChanged)
        }
        if let slider = slider, case .slider(let min, let max) = type {
            slider.minimumValue = min
            slider.maximumValue = max
            slider.addTarget(form, action: #selector(BaseForm.controlValueChanged(sender:)), for: .valueChanged)
        }
        if let segmentedControl = segmentedControl, case .segmentedControl(let options) = type {
            segmentedControl.removeAllSegments()
            var index = 0
            for key in options {
                if let icon = form.icon(for: key) {
                    segmentedControl.insertSegment(with: icon, at: index, animated: false)
                }
                else {
                    segmentedControl.insertSegment(withTitle: form.label(for: key), at: index, animated: false)
                }
                index += 1
            }
            form.modelToControl(keys: [self.key])  // update selection after reset titles
            segmentedControl.addTarget(form, action: #selector(BaseForm.controlValueChanged(sender:)), for: .valueChanged)
        }
        if let textView = textView {
            textView.delegate = form
            textView.inputAccessoryView = form.inputAccessoryView
        }
        
        if case .option(let keys) = type {
            self.optionKeyLabels = keys.reduce(into: [String:String](), {
                $0[$1] = form.label(for: $1)
            } )
        }
        
        if setupType == .stackView && self.isSelectable {
            print("add tap gesture")
            let tapGesture = UIButtonGestureRecognizer(target: self, action: #selector(handleStackViewTapGesture(_:)))
            self.addGestureRecognizer(tapGesture)
        }
        form.signal(rowView: self, event: .setup)    // signal event
    }

    // value -> control
    open func update(value: Any?) {
        switch type {
        //case .editText(let editType):
        case .editText:
            self.editTextField?.text = value as? String
        case .uiSwitch:
            self.uiSwitch?.isOn = value as? Bool ?? false
        case .slider:
            self.slider?.value = value as? Float ?? 0
        case .segmentedControl(let options):
            // set index by key
            if let key = value as? String {
                if let index = options.firstIndex(of: key) {
                    self.segmentedControl?.selectedSegmentIndex = index
                }
            }
        case .textView:
            self.textView?.text = value as? String
        case .optionValue(let optionKey):   // set checkmark according to the optionValue
            if let string = value as? String {  // single value
                if let cell = self.cell {
                    cell.accessoryType = string == optionKey ? .checkmark : .none
                }
            }
            else if let strings = value as? [String] {  // multiple values
                if let cell = self.cell {
                    cell.accessoryType = strings.contains(optionKey) ? .checkmark : .none
                }
            }
        case .option:
            if let label = self.descriptionLabel {
                if let string = value as? String {
                    if string.isEmpty {
                        label.text = self.auxiliaryLabel
                    }
                    else {
                        label.text = optionKeyLabels?[string] ?? string
                    }
                }
                else if let strings = value as? [String] {
                    if strings.count == 0 {
                        label.text = self.auxiliaryLabel
                    }
                    else {
                        let mappedLabels = strings.map { optionKeyLabels?[$0] ?? $0 }
                        label.text = mappedLabels.joined(separator: ", ")
                    }
                }
                else {
                    label.text = self.auxiliaryLabel
                }
            }
        case .sectionHeader, .simpleText, .button:
            break
        }
    }
    
    // control -> value
    open var value: Any? {
        switch type {
        case .editText(let editType):
            switch editType {
            case .integer:
                if let text = self.editTextField?.text {
                    return Int(text)
                }
            case .currency, .number:
                if let text = self.editTextField?.text {
                    return Double(text)
                }
            default:
                return self.editTextField?.text
            }
            return nil
        case .uiSwitch:
            return self.uiSwitch?.isOn
        case .slider:
            return self.slider?.value
        case .segmentedControl(let options):
            if let index = self.segmentedControl?.selectedSegmentIndex {
                if index >= 0 {
                    return options[index]
                }
            }
            return nil
        case .textView:
            return self.textView?.text
        // case .optionValue(let optionKey), option is a little bit different that it always set directly to model
        default:
            return nil
        }
    }       // get value from control
}


extension FormRowView {
    
    @IBAction func handleStackViewTapGesture(_ gestureRecognizer : UIButtonGestureRecognizer ) {
        guard gestureRecognizer.view != nil else { return }
        switch gestureRecognizer.state {
        case .began:
            self.backgroundColor = .lightGray
            print("began")
        case .changed:
            if gestureRecognizer.touchInside {
                self.backgroundColor = .lightGray
            }
            else {
                self.backgroundColor = .clear
            }
            print("changed")
        case .ended:
            self.backgroundColor = .clear
            print("ended")
        case .cancelled:
            self.backgroundColor = .clear
            print("cancalled")
        default:
            print(gestureRecognizer.state.rawValue)
            break
        }
    }
    
}
