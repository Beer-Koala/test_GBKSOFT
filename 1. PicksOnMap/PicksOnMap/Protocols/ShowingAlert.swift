//
//  ShowingAlert.swift
//  PicksOnMap
//
//  Created by BeerKoala on 6/8/19.
//  Copyright © 2019 a.kryvchykov. All rights reserved.
//

import UIKit

protocol ShowingAlert {

    func showAlert(with title: String, and message: String)
    func show(error: AppError)
    func present(_: UIViewController, animated: Bool, completion: (() -> Void)?) // standart UIViewController func
}

extension ShowingAlert {
    func showAlert(with title: String, and message: String) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: UIAlertController.TextConstants.ok.rawValue, style: .default))

        self.present(alert, animated: true, completion: nil)
    }

    func show(error: AppError) {
        self.showAlert(with: UIAlertController.TextConstants.error.rawValue, and: error.rawValue)
    }
}
