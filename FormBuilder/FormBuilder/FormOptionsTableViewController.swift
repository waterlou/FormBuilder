//
//  FormOptionsTableViewController.swift
//  FormBuilder
//
//  Created by Water Lou on 15/8/2018.
//  Copyright © 2018 Water Lou. All rights reserved.
//

import UIKit

open class FormOptionsTableViewController<Data: FormDataMappable>: FormTableViewController {

    var headerTitle: String?
    var key: String!
    var optionKeys: [String] = []
    
    public init(headerTitle: String?, data: Data, key: String, optionKeys: [String],
                labels: [String: String]?, icons: [String: UIImage]?) {
        super.init(style: .grouped)
        
        self.headerTitle = headerTitle
        self.key = key
        self.optionKeys = optionKeys
        let form = Form<Data>(self, data: data)
        form.labels = labels
        form.icons = icons
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
        
        form._subscribe(key: nil, event: .valueChanged) { form,rowView,_ in
            if let form = form as? Form<Data>, !form.lastAssignIsMultiValue {   // hack to close
                self.doDismiss(animated: true)
            }
        }
    }
    
    open override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return headerTitle ?? "Options"
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
