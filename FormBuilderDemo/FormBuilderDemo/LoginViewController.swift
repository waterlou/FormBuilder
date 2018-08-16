//
//  LoginExampleViewController.swift
//  FormBuilderDemo
//
//  Created by Water Lou on 15/8/2018.
//  Copyright © 2018 Water Lou. All rights reserved.
//

import UIKit
import FormBuilder

class LoginViewController: UIViewController {
  
    @IBOutlet weak var scrollViewBottomConstraint: NSLayoutConstraint!
    
    class Data: FormDataMappable {
        var email: String?
        var password: String?
        func mapping(map: FormDataMapping) {
            email       <- map["email"]
            password    <- map["password"]
        }
    }

    @IBOutlet weak var stackView: FormStackView!
    var form: Form<Data>!
    let data = Data()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.form = Form(self, data: data)
        
        FormRowViewOptions.setDefault(FormRowViewOptions(
            minimumLabelWidth: 72.0
        ))
        
        // define views
        form += [
            ("email", .editText(editTextType: .email)),
            ("password", .editText(editTextType: .password)),
        ]
        
        // define labels
        form.labels = [ // define labels
            "email" : "E-mail",
            "password" : "Password",
        ]
 
        // setup stackview
        stackView.form = form
        stackView.setupForm()
        
        // so it will enable scrollview when keyboard popup and need scroll
        form.watchKeyboardNotifications(constraint: scrollViewBottomConstraint)
        
        // cleanup default setting (optional)
        FormRowViewOptions.resetDefault()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        form.becomeFirstResponder()
    }

}
