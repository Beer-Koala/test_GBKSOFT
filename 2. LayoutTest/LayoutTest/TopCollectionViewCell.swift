//
//  TopCollectionViewCell.swift
//  LayoutTest
//
//  Created by BeerKoala on 6/18/19.
//  Copyright © 2019 a.kryvchykov. All rights reserved.
//

import UIKit

@IBDesignable
class TopCollectionViewCell: UICollectionViewCell {

    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }

}
