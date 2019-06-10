//
//  Pressable.swift
//  PicksOnMap
//
//  Created by BeerKoala on 6/10/19.
//  Copyright © 2019 a.kryvchykov. All rights reserved.
//

import UIKit

@objc protocol Pressable {
    func handleTap(gestureReconizer: UITapGestureRecognizer)
}

extension Pressable {
    func addTapGestureRecognizer(to view: UIView) {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tapRecognizer)
    }
}
