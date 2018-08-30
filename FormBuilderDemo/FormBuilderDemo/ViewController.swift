//
//  ViewController.swift
//  FormBuilderDemo
//
//  Created by Water Lou on 13/7/2018.
//  Copyright © 2018 Water Lou. All rights reserved.
//

import UIKit
import FormBuilder

class ViewController: FormTableViewController {
    
    class Data: FormDataMappable {
        
        var option: [String] = ["option1", "option2"]
        
        func mapping(map: FormDataMapping) {
            option <- map["option"]
        }
    }
    
    var data = Data()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // create form with data, add row
        let form = Form<FormNoData>(self, data: FormNoData())
        form += [   // define views
            ("tableview", .button),
            ("stackview", .button),
            ("scrollstackview", .button),
            ("login", .button),
            ("option", .button),
            ("showhide", .button),
        ]
        
        // setup labels
        form.labels = [ // define labels
            "tableview": "Table View",
            "stackview": "Stack View",
            "scrollstackview": "Scroll Stack View",
            "login": "Login Example",
            "showhide": "Show Hide Example",
        ]
        
        // subscribe actions
        form.subscribe(key: nil, event: .buttonClicked) { [unowned self] form, rowView, event, data in
            switch rowView.key {
            case "tableview":
                self.performSegue(withIdentifier: "simpleTableViewSegue", sender: nil)
            case "stackview":
                self.performSegue(withIdentifier: "simpleStackViewSegue", sender: nil)
            case "scrollstackview":
                self.performSegue(withIdentifier: "scrollableStackViewSegue", sender: nil)
            case "login":
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
            case "showhide":
                self.performSegue(withIdentifier: "showHideSegue", sender: nil)
            case "option":
                let labels = ["option1": "Option 1", "option2": "Option 2"]
                let optionKeys = ["option1", "option2"]
                let optionsViewController = FormOptionsTableViewController(headerTitle: "Option", data: data, key: "option", optionKeys: optionKeys, labels: labels, icons: nil)
                self.navigationController?.pushViewController(optionsViewController, animated: true)
            default:
                break
            }
        }
        
        self.form = form
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

