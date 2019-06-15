//
//  UIAlertController+extension.swift
//  PicksOnMap
//
//  Created by BeerKoala on 6/9/19.
//  Copyright © 2019 a.kryvchykov. All rights reserved.
//

import UIKit

extension UIAlertController {
    class func showAlertWithTextField(in viewController: UIViewController,
                                      title: String? = TextConstants.typeTitleText.rawValue,
                                      message: String?,
                                      completion: @escaping (String) -> Void) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.placeholder = TextConstants.titleText.rawValue
        }
        let confirmAction = UIAlertAction(title: TextConstants.ok.rawValue, style: .default) { [weak alertController] _ in
            guard let alertController = alertController, let text = alertController.textFields?.first?.text else { return }
            completion(text)
        }
        alertController.addAction(confirmAction)
        let cancelAction = UIAlertAction(title: TextConstants.cancel.rawValue, style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        viewController.present(alertController, animated: true, completion: nil)
    }

    class func askToDo(in viewController: UIViewController, title: String, completion: @escaping () -> Void) {
        let alertController = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: TextConstants.yes.rawValue, style: .default) { _ in
            completion()
        }
        alertController.addAction(confirmAction)
        let cancelAction = UIAlertAction(title: TextConstants.no.rawValue, style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        viewController.present(alertController, animated: true, completion: nil)
    }

    enum TextConstants: String {
        // swiftlint:disable identifier_name
        case ok = "OK"
        case cancel = "Cancel"
        case yes = "Да"
        case no = "Нет"

        case error = "Ошибка"
        case titleText = "Название"
        case typeTitleText = "Введите название:"
        // swiftlint:enable identifier_name
    }
}
