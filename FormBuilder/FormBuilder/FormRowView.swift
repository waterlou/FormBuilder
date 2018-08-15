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
        public enum OptionType {
            case none
            case single
            case multiple
            case date
        }
        public enum EditTextType {
            case text       // normal text
            case email      // email address
            case password   // password
            case integer    // integer number
            case number     // double
            case currency(prefix: String)   // double currency
        }
        public enum ButtonActionType {
            case segue(segueIdentifier: String)
        }
        
        case undefined
        case sectionHeader
        case simpleText
        case option(optionType: OptionType)
        case editText(editTextType: EditTextType)
        case uiSwitch
        case slider(min: Float, max: Float)
        case segmentedControl(options: [String])
        case textView
        case button
        
        enum FormBuilderXibIndex: Int {
            case label = 0
            case textField = 1
            case uiSwitch = 2
            case slider = 3
            case segmentedControl = 4
            case textView = 5
        }
        
        var xibIndex: FormBuilderXibIndex {
            switch self {
            case .undefined, .sectionHeader, .simpleText, .button:
                return .label
            case .option:
                return .label   // not implemented yet
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
    open var key: String?

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
 
    var type: BasicType = .undefined
    open var formTransform: FormTransformProtocol? = nil

    public var isSectionHeader: Bool {
        if case .sectionHeader = type {
            return true
        }
        return false
    }
    
    public var isSelectable: Bool = false
    
    // tranform from type to view
    internal class func rowView(_ owner: Any, type: BasicType, options: FormRowViewOptions? = nil) -> FormRowView {
        let bundle = options?.bundle ?? Bundle(for: FormRowView.self)
        let nib = UINib(nibName: options?.nibName ?? "FormBuilderBasic", bundle: bundle)
        let view = nib.instantiate(withOwner: owner)[type.xibIndex.rawValue] as! FormRowView
        view.type = type
        
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
        return view
    }
    
    // types -> views
    public class func build(_ owner: Any, _ viewTypePairs: [(String, BasicType)], options: FormRowViewOptions? = nil, nibName: String? = nil, bundle: Bundle? = nil) -> [FormRowView] {
        var rowViews = [FormRowView]()
        for (key, viewType) in viewTypePairs {
            let rowView = self.rowView(owner, type: viewType, options: options)
            rowView.key = key
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
    open func setup(form: BaseForm) {
        guard let key = key else { fatalError("key not set") }
        // you can setup label, icon
        if let titleLabel = titleLabel {
            titleLabel.text = form.label(for: key)
        }
        if let editTextField = editTextField, case .editText(let editType) = type {
            switch editType {
            case .currency:
                editTextField.keyboardType = .decimalPad
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
            editTextField.delegate = form
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
            form.modelToControl(keys: [self.key!])  // update selection after reset titles
            segmentedControl.addTarget(form, action: #selector(BaseForm.controlValueChanged(sender:)), for: .valueChanged)
        }
        if let textView = textView {
            textView.delegate = form
            textView.inputAccessoryView = form.inputAccessoryView
        }
        
        form.modelToControl(keys: [key])    // load data
        form.signal(key: key, event: .setup)    // signal event
    }

    open var errors: [Error]? {
        didSet {
            // response error to screen
        }
    }

    // value -> control
    open func update(value: Any?) {
        switch type {
        case .editText(let editType):
            self.editTextField?.text = value as? String
        case .uiSwitch:
            self.uiSwitch?.isOn = value as? Bool ?? false
        case .slider:
            self.slider?.value = value as? Float ?? 0
        case .segmentedControl(let options):
            // set index by key
            if let key = value as? String {
                if let index = options.index(of: key) {
                    self.segmentedControl?.selectedSegmentIndex = index
                }
            }
        case .textView:
            self.textView?.text = value as? String
        default:
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
        default:
            return nil
        }
    }       // get value from control

}
