//
//  UIAlertController+extension.swift
//  PicksOnMap
//
//  Created by BeerKoala on 6/9/19.
//  Copyright © 2019 a.kryvchykov. All rights reserved.
//

import UIKit

extension UIAlertController {
    class func showAlertWithTextField(in viewController: UIViewController, title: String?, message: String?, completion: @escaping (String) -> Void) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.placeholder = "Название"
        }
        let confirmAction = UIAlertAction(title: "OK", style: .default) { [weak alertController] _ in
            guard let alertController = alertController, let text = alertController.textFields?.first?.text else { return }
            completion(text)
        }
        alertController.addAction(confirmAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        viewController.present(alertController, animated: true, completion: nil)
    }
}
