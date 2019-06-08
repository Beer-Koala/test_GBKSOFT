//
//  LoginModel.swift
//  PicksOnMap
//
//  Created by BeerKoala on 6/8/19.
//  Copyright © 2019 a.kryvchykov. All rights reserved.
//

import Foundation
import GoogleSignIn
import FirebaseAuth

class LoginModel: NSObject {
    weak var delegate: LoginModelDelegate?

    init(with viewController: LoginModelDelegate) {
        self.delegate = viewController
    }
}

extension LoginModel: GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        if let error = error {
            delegate?.showAlert(with: "Google", and: "Error with login")
            print(error)
            return
        }

        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)

        Auth.auth().signIn(with: credential) { (_, error) in
            if let error = error {
                self.delegate?.showAlert(with: "Authorization", and: "Error with login")
                print(error)
                return
            }
        }
    }

//    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
//        // Perform any operations when the user disconnects from app here.
//        // ...
//    }
}

protocol LoginModelDelegate: AnyObject, ShowingAlert {

}
