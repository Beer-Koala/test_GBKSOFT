//
//  LoginViewController.swift
//  PicksOnMap
//
//  Created by BeerKoala on 6/6/19.
//  Copyright © 2019 a.kryvchykov. All rights reserved.
//

import UIKit
import GoogleSignIn
import FirebaseAuth

class LoginViewController: UIViewController {

    private enum Constants: String {
        case identifierToMainTabBarVC = "toMainTabBarVC"
    }

    @IBOutlet weak var signWithGoogleButton: GIDSignInButton!
    var loginModel: LoginModel!

    override func viewDidLoad() {
        super.viewDidLoad()

        loginModel = LoginModel(with: self as LoginModelDelegate)

        GIDSignIn.sharedInstance()?.uiDelegate = self
        GIDSignIn.sharedInstance()?.delegate = loginModel

        Auth.auth().addStateDidChangeListener { _, user in
            if user != nil {
                self.performSegue(withIdentifier: Constants.identifierToMainTabBarVC.rawValue, sender: self)
            } else {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
}

// MARK: GIDSignInUIDelegate
extension LoginViewController: GIDSignInUIDelegate {
}

// MARK: LoginModelDelegate
extension LoginViewController: LoginModelDelegate {
}
