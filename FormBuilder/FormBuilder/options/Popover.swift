//
//  Popover.swift
//  FormBuilder
//
//  Created by Water Lou on 15/8/2018.
//  Copyright © 2018 Water Lou. All rights reserved.
//

import UIKit

extension UIViewController {

    func showDirectionPopup(viewController: UIViewController, sender: UIView) {
        viewController.modalPresentationStyle = .pageSheet
        viewController.preferredContentSize = CGSize(width: 300, height: 200)
        //let presentationController = viewController.presentationController as! UIPopoverPresentationController
        //presentationController.sourceView = sender
        //presentationController.sourceRect = sender.bounds
        //presentationController.permittedArrowDirections = [.down, .up]
        self.present(viewController, animated: true)
    }

}
