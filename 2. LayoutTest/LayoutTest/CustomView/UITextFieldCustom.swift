//
//  UITextFieldRounded.swift
//  LayoutTest
//
//  Created by BeerKoala on 6/17/19.
//  Copyright © 2019 a.kryvchykov. All rights reserved.
//

import UIKit

@IBDesignable
class UITextFieldCustom: UITextField {

    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }

    @IBInspectable var letterSpacing: CGFloat = 0 {
        didSet {
            guard let text = self.text else { return }

            let attributedString = NSMutableAttributedString(string: text)
            attributedString.addAttribute(NSAttributedString.Key.kern, value: letterSpacing, range: NSRange(location: 0, length: attributedString.length - 1))
            self.attributedText = attributedString
        }
    }
}
