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
        
        mutating func mapping(map: FormDataMapping) {
            address <- map["address"]
            name    <- map["name"]
            phone   <- map["phone"]
        }
    }
    
    var form: Form<Data>!

    @IBOutlet weak var stackView: FormStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let data = Data(name: "Lou Chi Wai", address: "Golden", phone: "26287519")
        self.form = Form(self, data: data)
        
        // define views
        form += FormRowView.build(self, [
            ("field1",      .simpleText),
            ("switch1",     .uiSwitch),
            ("slider1",     .slider(min: 0, max: 1)),
            ("segment1",    .segmentedControl(options: ["male", "female"])),
            ("name",        .editText(editTextType: .text)),
            ("address",     .editText(editTextType: .text)),
            ("phone",       .editText(editTextType: .text)),
            ("field2",      .simpleText),
            ("field3",      .textView),
        ]) //, nibName: "MyFormLayout", bundle: Bundle.main)
        
        // define labels
        form.labels = [ // define labels
            "field1"    :   "Occupcation",
            "field2"    :   "Industries",
            "name"      :   "Name",
            "address"   :   "Address",
            "phone"     :   "Phone",
        ]

        stackView.form = form
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
