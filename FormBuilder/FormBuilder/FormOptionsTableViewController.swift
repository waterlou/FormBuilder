//
//  FormOptionsTableViewController.swift
//  FormBuilder
//
//  Created by Water Lou on 15/8/2018.
//  Copyright © 2018 Water Lou. All rights reserved.
//

import UIKit

open class FormOptionsTableViewController<Data: FormDataMappable>: FormTableViewController {

    var key: String!
    var optionKeys: [String] = []
    
    public init(data: Data, key: String, optionKeys: [String], labels: [String: String]) {
        super.init(style: .grouped)
        
        self.key = key
        self.optionKeys = optionKeys
        let form = Form<Data>(self, data: data)
        form.labels = labels
        self.form = form
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        optionKeys.forEach {
            form.appendRow(rowView: FormRowView.rowView(self, key: key, type: .optionValue(key: $0)))
        }
        
        form.subscribe(key: nil, event: .buttonClicked) { form,rowView,_,_ in
            if let rowView = rowView as? FormRowView {
                if case .optionValue(let optionKey) = rowView.type {
                    form.assignOptionValue(optionKey: optionKey, for: rowView.key!)
                    form.signal(rowView: rowView, event: .valueChanged)
                }
            }
            //self.doDismiss(animated: true)
        }
    }
    
    open override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Options"
    }
    
    internal func doDismiss(animated: Bool) {
        if let navigationController = navigationController {
            navigationController.popViewController(animated: animated)
        }
        else {
            self.dismiss(animated: animated, completion: nil)
        }
    }

}
