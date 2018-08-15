//
//  TestFormTableViewController.swift
//  FormBuilderDemo
//
//  Created by Water Lou on 13/7/2018.
//  Copyright © 2018 Water Lou. All rights reserved.
//

import UIKit
import FormBuilder

class TestFormTableViewController: FormTableViewController {

    class Data: FormDataMappable, CustomDebugStringConvertible {
        var name: String?
        var address: String?
        var phone: String?
        var switch1: Bool = false
        var slider1: Float = 0.5
        var segment1: String = ""
        var note: String = ""

        func mapping(map: FormDataMapping) {
            name    <- map["name"]
            address <- map["address"]
            phone   <- map["phone"]
            switch1 <- map["switch1"]
            slider1 <- map["slider1"]
            segment1 <- map["segment1"]
            note <- map["note"]
        }
        
        var debugDescription: String {
            return "\(String(describing: self.name)), \(String(describing: self.phone)), \(self.switch1), \(self.slider1), \(self.segment1), \(self.note)"
        }
    }
    
    let data = Data()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // setup data
        data.name = "Lou Chi Wai"
        data.address = "Golden"
        data.phone = "26287519"
        data.slider1 = 0.2
        data.segment1 = "male"
        
        // form options
        FormRowViewOptions.setDefault(FormRowViewOptions(
            minimumHeight: 66.0,
            minimumLabelWidth: 100.0
        ))
        
        // create form with data, add row
        form = Form<Data>(self, data: data)
        form += [   // define views
            ("section1", .sectionHeader),
                ("field1", .simpleText),
                ("switch1", .uiSwitch),
                ("slider1", .slider(min: 0.0, max: 1.0)),
                ("segment1",    .segmentedControl(options: ["male", "female"])),
            ("section2", .sectionHeader),
                ("name", .editText(editTextType: .text)),
                ("address", .editText(editTextType: .text)),
                ("phone", .editText(editTextType: .text)),
                ("field2", .simpleText),
                ("field3", .simpleText),
                ("button1", .button),
                ("note", .textView),
        ]
        
        // setup labels
        form.labels = [ // define labels
            "name": "Name",
            "address": "Address",
            "phone": "Phone",
            "slider1": "Test Slider",
            "male": "Male",
            "female": "Female",
            "segment1": "Gender",
            "button1": "Click Me",
        ]
        
        // subscribe actions
        form.subscribe(key: "button1", event: .buttonClicked) { _, _, _, _ in
            print("button clicked")            
        }
        
        Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { _ in
            print(self.data)
        }
    }

}