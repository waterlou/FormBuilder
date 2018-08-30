//
//  ShowHideTableViewController.swift
//  FormBuilderDemo
//
//  Created by Water Lou on 30/8/2018.
//  Copyright © 2018 Water Lou. All rights reserved.
//

import UIKit
import FormBuilder

class ShowHideTableViewController: FormTableViewController {
    
    class Data: FormDataMappable {
        var segment: String = "phone"
        var phone: String?
        var address: String?
        
        func mapping(map: FormDataMapping) {
            phone        <- map["phone"]
            address     <- map["address"]
            segment     <- map["segment"]
        }
    }
    
    @IBOutlet weak var debugLabel: UILabel!
    
    let data = Data()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setup data
        data.address = "Golden"
        data.phone = "26287519"
        
        // form options
        FormRowViewOptions.setDefault(FormRowViewOptions(
            titleFont: UIFont.systemFont(ofSize: 13),
            minimumHeight: 44.0,
            editTextFont: UIFont.systemFont(ofSize: 17)
        ))
        
        // create form with data, add row
        let form = Form<Data>(self, data: data)
        form += [   // define views
            ("section1", .sectionHeader),
            ("segment",    .segmentedControl(keys: ["phone", "address"])),
            ("phone", .editText(type: .phone)),
            ("address", .editText(type: .text)),
        ]
        
        // when segment value changed
        form.subscribe(key: "segment", event: .valueChanged) { form, rowView, event, data in
            // show hide button
            print("switching")
            switch data.segment {
            case "phone":
                form.setHidden(key: "phone", hidden: false)
                form.setHidden(key: "address", hidden: true)
            case "address":
                form.setHidden(key: "phone", hidden: true)
                form.setHidden(key: "address", hidden: false)
            default:
                break
            }
        }
        
        self.form = form
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        form.becomeFirstResponder()
    }
    
    
}
