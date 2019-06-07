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
    func present(_: UIViewController, animated: Bool, completion: (() -> Void)?) // standart UIViewController func
}

extension ShowingAlert {
    func showAlert(with title: String, and message: String) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "OK", style: .default))

        self.present(alert, animated: true, completion: nil)
    }
}
