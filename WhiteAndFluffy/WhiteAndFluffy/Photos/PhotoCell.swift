//
//  PhotoCell.swift
//  WhiteAndFluffy
//
//  Created by Егор Шкарин on 29.01.2022.
//

import UIKit

class PhotoCell: UICollectionViewCell {
    private let image: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.backgroundColor = .red
        image.layer.cornerRadius = 10
        return image
    }()
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    func configure(with imageData: Data) {
        setup()
    }
    
    private func setup() {
        addSubview(containerView)
        containerView.pins()
        containerView.addSubview(image)
        let imageInsets = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        image.pins(imageInsets)
    }
}