//
//  Form.swift
//  FormBuilder
//
//  Created by Water Lou on 13/7/2018.
//  Copyright © 2018 Water Lou. All rights reserved.
//

import UIKit

// Bind Model and View

public class Form<M: FormDataMappable>: BaseForm {
    
    //public var mapper = Mapper<M>()
    public var data: M?                          // data model

    public init(_ viewController: UIViewController, data: M) {
        super.init(viewController)
        self.data = data
    }

    // two ways binding
    override func controlToModel(keys: [String]? = nil) {
        let map = FormDataMapping(form: self, mappingType: .fromControl, availableKeys: keys)
        data?.mapping(map: map)
    }

    override func modelToControl(keys: [String]? = nil) {
        let map = FormDataMapping(form: self, mappingType: .toControl, availableKeys: keys)
        data?.mapping(map: map)
    }
    
}

