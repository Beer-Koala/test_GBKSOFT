//
//  LongPressable.swift
//  PicksOnMap
//
//  Created by BeerKoala on 6/10/19.
//  Copyright © 2019 a.kryvchykov. All rights reserved.
//

import UIKit

@objc protocol LongPressable {
    func handleLongPress(gestureReconizer: UILongPressGestureRecognizer)
}

extension LongPressable {
    func addLongPressGesturerecognizer(to view: UIView) {
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        //longPressRecognizer.delaysTouchesBegan = true //!!!
        view.addGestureRecognizer(longPressRecognizer)
    }
}
