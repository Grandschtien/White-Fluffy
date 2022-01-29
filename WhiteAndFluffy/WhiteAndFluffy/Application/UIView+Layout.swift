//
//  UIView+Layout.swift
//  WhiteAndFluffy
//
//  Created by Егор Шкарин on 29.01.2022.
//

import UIKit

extension UIView {
    func top(_ constant: CGFloat = 0.0) {
        self.topAnchor.constraint(equalTo: self.superview!.topAnchor, constant: constant).isActive = true
    }

    func bottom(_ constant: CGFloat = 0.0) {
        self.bottomAnchor.constraint(equalTo: self.superview!.bottomAnchor, constant: constant).isActive = true
    }

    func leading(_ constant: CGFloat = 0.0) {
        self.leadingAnchor.constraint(equalTo: self.superview!.leadingAnchor, constant: constant).isActive = true
    }

    func trailing(_ constant: CGFloat = 0.0) {
        self.trailingAnchor.constraint(equalTo: self.superview!.trailingAnchor, constant: constant).isActive = true
    }

    func horizontal(_ leading: CGFloat = 0.0, trailing: CGFloat = 0.0) {
        self.leading(leading)
        self.trailing(trailing)
    }

    func vertical(_ top: CGFloat = 0.0, bottom: CGFloat = 0.0) {
        self.top(top)
        self.bottom(bottom)
    }

    func centerY() {
        self.centerYAnchor.constraint(equalTo: self.superview!.centerYAnchor).isActive = true
    }
    /// Закрепление на все 4 констреинта с учетом отсупов (верх, лево, право, низ)
    func pins(_ insets: UIEdgeInsets = .zero) {
        self.top(insets.top)
        self.leading(insets.left)
        self.trailing(insets.right)
        self.bottom(insets.bottom)
    }
}
