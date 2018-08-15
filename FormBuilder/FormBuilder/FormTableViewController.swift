//
//  FormTableViewController.swift
//  FormBuilder
//
//  Created by Water Lou on 13/7/2018.
//  Copyright © 2018 Water Lou. All rights reserved.
//

import UIKit

open class FormTableViewController: UITableViewController {

    public var form: BaseForm!
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        self.clearsSelectionOnViewWillAppear = false
        tableView.rowHeight = UITableViewAutomaticDimension // auto layout
    }

    // MARK: - Table view data source

    override open func numberOfSections(in tableView: UITableView) -> Int {
        return form.numberOfSections
    }

    override open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return form.numberOfRows(section: section)
    }

    override open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let rowView = form.rowView(row: indexPath.row, section: indexPath.section) else { fatalError("cannot get rowView") }
        guard let key = rowView.key else { fatalError("key not set") }
        if let cell = tableView.dequeueReusableCell(withIdentifier: key) {
            return cell
        }
        let cell = rowView.cell(withIdentifier: key)
        cell.formRowViewProtocol.setup(form: form)  // setup control
        return cell
    }
    
    open override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return form.header(forSection: section)
    }
    
    open override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        guard let rowView = form.rowView(row: indexPath.row, section: indexPath.section) else { fatalError("cannot get rowView") }
        return rowView.isSelectable
    }
    
    
}
