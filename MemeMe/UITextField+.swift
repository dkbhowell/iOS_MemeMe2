//
//  UITextField+.swift
//  MemeMe
//
//  Created by Dustin Howell on 5/30/17.
//  Copyright © 2017 Dustin Howell. All rights reserved.
//

import UIKit

extension UITextField {
    func configure(text: String? = nil, delegate: UITextFieldDelegate? = nil, defaultAttributes: [String:Any]? = nil) {
        if let text = text {
            self.text = text
        }
        if let delegate = delegate {
            self.delegate = delegate
        }
        if let defAttr = defaultAttributes {
            self.defaultTextAttributes = defAttr
        }
    }
}
