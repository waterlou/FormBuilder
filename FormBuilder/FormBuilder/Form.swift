//
//  Form.swift
//  FormBuilder
//
//  Created by Water Lou on 13/7/2018.
//  Copyright © 2018 Water Lou. All rights reserved.
//

import UIKit

// Bind Model and View

public class Form<M: FormDataMappable>: BaseForm {
    
    public var data: M
    public var lastAssignIsMultiValue = false

    ///// reactive
    
    public class FormSubscription {
        public typealias Closure = (Form<M>, FormRowViewProtocol, Event, M) -> ()
        
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
    internal var subscriptions: [FormSubscription] = []
    
    // subscribe a event
    public func subscribe(key: String?, event: Event, closure: @escaping FormSubscription.Closure) {
        subscriptions.append(FormSubscription(key: key, event: event, closure: closure))
    }
    
    // subscribe some event to same closure
    public func subscribe(key: String?, events: [Event], closure: @escaping FormSubscription.Closure) {
        events.forEach { event in
            subscriptions.append(FormSubscription(key: key, event: event, closure: closure))
        }
    }

    
    // signal a event
    public override func signal(rowView: FormRowViewProtocol, event: Event) {
        let key = rowView.key
        super.signal(rowView: rowView, event: event)
        for subscription in self.subscriptions {
            if (subscription.key == nil || subscription.key! == key) && event == subscription.event {
                subscription.closure(self, rowView, event, self.data)
            }
        }
    }
    
    ///////////////
    
    public init(_ viewController: UIViewController, data: M) {
        self.data = data
        super.init(viewController)
    }
    
    // two ways binding
    open override func controlToModel(keys: [String]? = nil) {
        let map = FormDataMapping(form: self, mappingType: .fromControl, availableKeys: keys)
        data.mapping(map: map)
    }

    open override func modelToControl(keys: [String]? = nil) {
        let map = FormDataMapping(form: self, mappingType: .toControl, availableKeys: keys)
        data.mapping(map: map)
    }
    
    // set option value in model and update UI
    open override func assignOptionValue(optionKey: String, for key: String) -> Bool {
        let map = FormDataMapping(form: self, mappingType: .assignOption, availableKeys: [key])
        map.optionValue = optionKey
        data.mapping(map: map)
        modelToControl(keys: [key]) // update UI
        lastAssignIsMultiValue = map.isMultiOptionValue
        return map.isMultiOptionValue
    }

    override public func showOptions(rowView: FormRowViewProtocol, optionKeys: [String]) {
        let key = rowView.key
        let title = self.label(for: key)
        let optionsViewController = FormOptionsTableViewController(headerTitle: title, data: self.data, key: key, optionKeys: optionKeys, labels: self.labels, icons: self.icons)
        // chain valueChanged event to parent viewController
        optionsViewController.form._subscribe(key: nil, event: .valueChanged) { _,_,_ in
            self.signal(rowView: rowView, event: .valueChanged)
        }
        self.viewController?.showDirectionPopup(viewController: optionsViewController, sender: self.viewController!.view)
        //self.viewController?.navigationController?.pushViewController(optionsViewController, animated: true)
    }

    /*
    override public func showOptions(rowView: FormRowViewProtocol, optionKeys: [String]) {
        guard let key = rowView.key else { fatalError("key not set") }
        let optionsViewController = FormOptionsTableViewController(data: self.data!, key: key, optionKeys: optionKeys, labels: self.labels)
        // chain valueChanged event to parent viewController
        optionsViewController.form.subscribe(key: nil, event: .valueChanged) { _,_,_,_ in
            self.signal(rowView: rowView, event: .valueChanged)
        }
        self.viewController?.navigationController?.pushViewController(optionsViewController, animated: true)
    }
 */
}

