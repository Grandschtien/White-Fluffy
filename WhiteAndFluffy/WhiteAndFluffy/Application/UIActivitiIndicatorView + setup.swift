//
//  UIActivitiIndicatorView + setup.swift
//  WhiteAndFluffy
//
//  Created by Егор Шкарин on 30.01.2022.
//

import UIKit

extension UIActivityIndicatorView {
    func setup() {
        self.startAnimating()
        self.centerX()
        self.centerY()
        self.isHidden = false
    }
}
