//
//  ProfileViewController.swift
//  PicksOnMap
//
//  Created by BeerKoala on 6/7/19.
//  Copyright © 2019 a.kryvchykov. All rights reserved.
//

import UIKit
import FirebaseAuth
import GoogleSignIn

class ProfileViewController: UIViewController, ShowingAlert {

    @IBAction func logout(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            show(error: AppError.logoutError)
            print(signOutError)
        }
        GIDSignIn.sharedInstance()?.signOut()
    }

}
