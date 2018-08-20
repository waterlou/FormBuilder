//
//  TestFormStackViewController.swift
//  FormBuilderDemo
//
//  Created by Water Lou on 13/7/2018.
//  Copyright © 2018 Water Lou. All rights reserved.
//

import UIKit
import FormBuilder

class TestFormStackViewController: UIViewController {
    
    struct Data: FormDataMappable {
        
        var name: String?
        var address: String?
        var phone: String?
        var gender: String?
        
        mutating func mapping(map: FormDataMapping) {
            address <- map["address"]
            name    <- map["name"]
            phone   <- map["phone"]
            gender  <- map["segment1"]
        }
    }
    
    var form: Form<Data>!

    @IBOutlet weak var stackView: FormStackView!
    @IBOutlet weak var scrollViewBottomConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let data = Data(name: "Lou Chi Wai", address: "Golden", phone: "26287519", gender: "male")
        self.form = Form(self, data: data)
        
        // form options
        FormRowViewOptions.setDefault(FormRowViewOptions(
            minimumHeight: 66.0,
            minimumLabelWidth: 100.0
        ))
        
        // define views
        form += FormRowView.build(self, [
            ("field1",      .simpleText),
            ("button1", .button),
            ("switch1",     .uiSwitch),
            ("slider1",     .slider(min: 0, max: 1)),
            ("segment1",    .segmentedControl(keys: ["male", "female"])),
            ("name",        .editText(type: .text)),
            ("address",     .editText(type: .text)),
            ("phone",       .editText(type: .text)),
            ("field2",      .simpleText),
            ("field3",      .textView),
        ], options: .default)
        
        // define labels
        form.labels = [ // define labels
            "field1"    :   "Occupcation",
            "field2"    :   "Industries",
            "name"      :   "Name",
            "address"   :   "Address",
            "phone"     :   "Phone",
        ]
        
        form.subscribe(key: nil, event: .setup) { form, rowView, event, data in
            if let rowView = rowView as? FormRowView {
                if let textField = rowView.editTextField {
                    textField.textAlignment = .right
                    textField.borderStyle = .none
                }
            }
        }

        stackView.form = form
        
        // draw border around stackview
        StackViewBorderView(drawBounds: false, drawSeparator: true).attach(to: self.stackView)
        
        // monitor keyboard change
        if scrollViewBottomConstraint != nil {
            form.watchKeyboardNotifications(constraint: scrollViewBottomConstraint)
        }
        
        // Do any additional setup after loading the view.
        stackView.setupForm()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func doClose(_ sender: Any) {
        dismiss(animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
