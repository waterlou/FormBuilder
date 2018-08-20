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
        var option1: String = ""
        var option2: [String] = []
        var option3: String = ""

        func mapping(map: FormDataMapping) {
            name    <- map["name"]
            address <- map["address"]
            phone   <- map["phone"]
            switch1 <- map["switch1"]
            slider1 <- map["slider1"]
            segment1 <- map["segment1"]
            note <- map["note"]
            option1 <- map["option1"]
            option2 <- map["option2"]
            option3 <- map["option3"]
        }
        
        var debugDescription: String {
            return dumpClassVariables(obj: self)
//            return "\(String(describing: self.name)), \(String(describing: self.phone)), \(self.switch1), \(self.slider1), \(self.segment1), \(self.note), \(self.option1), \(self.option2)"
        }
    }
    
    @IBOutlet weak var debugLabel: UILabel!
    
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
            titleFont: UIFont.systemFont(ofSize: 13),
            minimumHeight: 66.0,
            minimumLabelWidth: 66.0,
            editTextFont: UIFont.systemFont(ofSize: 17),
            textBorderStyle: UITextBorderStyle.none,
            textAlignment: .left
        ))
        
        // create form with data, add row
        let form = Form<Data>(self, data: data)
        form += [   // define views
            ("section1", .sectionHeader),
                ("textfield1", .editText(type: .text)),
                ("switch1", .uiSwitch),
                ("slider1", .slider(min: 0.0, max: 1.0)),
                ("segment1",    .segmentedControl(keys: ["male", "female"])),
            ("section2", .sectionHeader),
                ("name", .editText(type: .text)),
                ("address", .editText(type: .text)),
                ("phone", .editText(type: .text)),
                ("field2", .simpleText),
                ("field3", .simpleText),
                ("button1", .button),
                ("option3", .option(keys: ["okey1", "okey2", "okey3", "okey4"])),
                ("note", .textView),
            ("singleOptionsSection", .sectionHeader),
                ("option1", .optionValue(key: "value1")),
                ("option1", .optionValue(key: "value2")),
                ("option1", .optionValue(key: "value3")),
                ("option1", .optionValue(key: "value4")),
            ("multipleOptionsSection", .sectionHeader),
                ("option2", .optionValue(key: "value1")),
                ("option2", .optionValue(key: "value2")),
                ("option2", .optionValue(key: "value3")),
                ("option2", .optionValue(key: "value4")),
        ]
        
        // setup labels
        form.labels = [ // define labels
            "section1": "Text Fields",
            "address": "Address",
            "phone": "Phone",
            "slider1": "Test Slider",
            "male": "Male",
            "female": "Female",
            "segment1": "Gender",
            "button1": "Click Me",
        ]
        
        // button action
        form.subscribe(key: "button1", event: .buttonClicked) { form, rowView, event, data in
            print("button clicked")            
        }
        
        // when segment value changed
        form.subscribe(key: "segment1", event: .valueChanged) { form, rowView, event, data in
            if data.segment1 == "male" {
                data.slider1 = 0.1
            }
            else {
                data.slider1 = 0.8
            }
            form.modelToControl(keys: ["slider1"])
        }
        
        // change debug message when any value changed
        form.subscribe(key: nil, event: .valueChanged) { [unowned self] form, rowView, event, data in
            self.debugLabel.text = data.debugDescription
        }
        form.subscribe(key: nil, event: .valueChanging) { [unowned self] form, rowView, event, data in
            self.debugLabel.text = data.debugDescription
        }
        
        self.form = form
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        form.becomeFirstResponder()
    }


}
