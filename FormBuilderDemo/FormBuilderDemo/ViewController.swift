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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // create form with data, add row
        form = Form<FormNoData>(self, data: FormNoData())
        form += [   // define views
            ("tableview", .button),
            ("stackview", .button),
            ("scrollstackview", .button),
        ]
        
        // setup labels
        form.labels = [ // define labels
            "tableview": "Table View",
            "stackview": "Stack View",
            "scrollstackview": "Scroll Stack View",
        ]
        
        // subscribe actions
        form.subscribe(key: nil, event: .buttonClicked) { _, rowView, _, _ in
            if let key = rowView.key {
                switch key {
                case "tableview":
                    self.performSegue(withIdentifier: "simpleTableViewSegue", sender: nil)
                case "stackview":
                    self.performSegue(withIdentifier: "simpleStackViewSegue", sender: nil)
                case "scrollstackview":
                    self.performSegue(withIdentifier: "scrollableStackViewSegue", sender: nil)
                default:
                    break
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

