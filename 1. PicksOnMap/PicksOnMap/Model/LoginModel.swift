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
            delegate?.show(error: AppError.googleAuthError)
            print(error)
            return
        }

        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)

        Auth.auth().signIn(with: credential) { (_, error) in
            if let error = error {
                self.delegate?.show(error: AppError.authError)
                print(error)
                return
            }
        }
    }
}

protocol LoginModelDelegate: AnyObject, ShowingAlert {

}
