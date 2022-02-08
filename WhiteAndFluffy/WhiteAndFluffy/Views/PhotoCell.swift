//
//  PhotoCell.swift
//  WhiteAndFluffy
//
//  Created by Егор Шкарин on 29.01.2022.
//

import UIKit
import SkeletonView

class PhotoCell: UICollectionViewCell {
    private let image: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.layer.masksToBounds = true
        image.contentMode = .scaleAspectFill
        image.layer.cornerRadius = 10
        image.backgroundColor = .lightGray
        return image
    }()
    private let containerView: UIView = {
        let view = UIView()
        //view.isSkeletonable = true
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    
    func configure(with viewModel: PhotoViewModel) {
        setup()
        image.kf.setImage(with: viewModel.resourceOfImage, options: [.fromMemoryCacheOrRefresh])
    }
    
    private func setup() {
        contentView.addSubview(containerView)
        containerView.pins()
        containerView.addSubview(image)
        let imageInsets = UIEdgeInsets(top: 10,
                                       left: 0,
                                       bottom: 0,
                                       right: 0)
        image.pins(imageInsets)
    }
    func hideSkeletonAnimations() {
        image.hideSkeleton()
    }
}
