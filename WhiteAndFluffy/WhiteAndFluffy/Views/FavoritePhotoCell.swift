//
//  FavoritePhotoCell.swift
//  WhiteAndFluffy
//
//  Created by Егор Шкарин on 30.01.2022.
//

import UIKit

class FavoritePhotoCell: UITableViewCell {
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    private let name: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        return label
    }()
    
    private let image: UIImageView = {
        var image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.layer.cornerRadius = 10
        image.contentMode = .scaleAspectFill
        image.layer.masksToBounds = true
        image.backgroundColor = .lightGray
        return image
    }()
    
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.alignment = .center
        stack.axis = .horizontal
        stack.spacing = 10
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    func configure(viewModel: PhotoViewModel) {
        setup()
        name.text = viewModel.userName
        image.kf.setImage(with: viewModel.resourceOfImage)
    }
    private func setup() {
        addSubview(containerView)
        containerView.pins()
        containerView.addSubview(image)
        image.leading(10)
        image.top(10, isIncludeSafeArea: false)
        image.bottom(-10, isIncludeSafeArea: false)
        image.widthAnchor.constraint(equalToConstant: frame.height).isActive = true
        containerView.addSubview(name)
        name.leadingAnchor.constraint(equalTo: image.trailingAnchor,
                                      constant: 10).isActive = true
        name.centerY()
        name.trailing(-10)
    }
}
