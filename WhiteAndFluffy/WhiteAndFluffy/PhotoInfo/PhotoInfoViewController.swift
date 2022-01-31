//
//  PhotoInfoViewController.swift
//  WhiteAndFluffy
//
//  Created by Егор Шкарин on 29.01.2022.
//  
//

import UIKit

final class PhotoInfoViewController: UIViewController {
    private let output: PhotoInfoViewOutput
    private var photoViewModel: PhotoInfoViewModel?
    private var isFavoritePhoto = false
    private var activityIndicator:UIActivityIndicatorView = {
        let activity = UIActivityIndicatorView()
        activity.translatesAutoresizingMaskIntoConstraints = false
        activity.style = UIActivityIndicatorView.Style.large
        return activity
    }()
    
    //Для обработки потери сети
    private let errorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        label.textAlignment = .center
        label.textColor = .black
        label.numberOfLines = 2
        return label
    }()
    private let errorButton: UIButton = {
        let button = UIButton(type: .roundedRect)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Обновить", for: .normal)
        button.setTitleColor(UIColor(named: "buttonColor"), for: .normal)
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(named: "buttonColor")?.cgColor
        return button
    }()
    private let errorStackView:UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 30
        stack.distribution = .fill
        stack.alignment = .center
        return stack
    }()
    
    private let image: UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = 10
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.layer.masksToBounds = true
        image.backgroundColor = .lightGray
        return image
    }()
    private let dateAndLocationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        label.textColor = .lightGray
        label.numberOfLines = 0
        return label
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 30, weight: .heavy)
        label.textColor = .black
        return label
    }()
    private let downloadsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 20, weight: .light)
        label.textColor = .lightGray
        return label
    }()
    
    private let favoriteButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 10
        button.backgroundColor = UIColor(named: "buttonColor")
        button.tintColor = .white
        return button
    }()
    
    init(output: PhotoInfoViewOutput) {
        self.output = output
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        output.viewDidLoad()
        setup()
        setupWaitingIndicator()
    }
}
//MARK: - Настройка layout
extension PhotoInfoViewController {
    private func setup() {
        self.image.isHidden = true
        self.nameLabel.isHidden = true
        self.dateAndLocationLabel.isHidden = true
        self.downloadsLabel.isHidden = true
        self.favoriteButton.isHidden = true
        view.backgroundColor = .white
        view.addSubview(image)
        image.top(30, isIncludeSafeArea: true)
        image.leading(30)
        image.trailing(-30)
        image.heightAnchor.constraint(equalToConstant: view.frame.height / 4).isActive = true
        view.addSubview(nameLabel)
        nameLabel.leading(30)
        nameLabel.trailing(-30)
        nameLabel.topAnchor.constraint(equalTo: image.bottomAnchor,
                                       constant: 20).isActive = true
        nameLabel.textAlignment = .center

        
        view.addSubview(dateAndLocationLabel)
        dateAndLocationLabel.leading(30)
        dateAndLocationLabel.trailing(-30)
        dateAndLocationLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor,
                                                  constant: 15).isActive = true
       
        dateAndLocationLabel.textAlignment = .center
        
        view.addSubview(downloadsLabel)
        downloadsLabel.leading(30)
        downloadsLabel.trailing(-30)
        downloadsLabel.topAnchor.constraint(equalTo: dateAndLocationLabel.bottomAnchor,
                                                  constant: 15).isActive = true
        
        downloadsLabel.textAlignment = .center
        
        view.addSubview(favoriteButton)
        
        favoriteButton.leading(30)
        favoriteButton.trailing(-30)
        favoriteButton.topAnchor.constraint(equalTo: downloadsLabel.bottomAnchor,
                                            constant: 40).isActive = true
        
        favoriteButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        favoriteButton.addTarget(self, action: #selector(likePhoto), for: .touchUpInside)
    }
    //MARK: - setupWaitingIndicator
    private func setupWaitingIndicator() {
        view.addSubview(activityIndicator)
        activityIndicator.setup()
    }
   
}

//MARK: - PhotoInfoViewInput
extension PhotoInfoViewController: PhotoInfoViewInput {
    func setupErrorView(with description: String) {
        DispatchQueue.main.async {[self] in
            activityIndicator.isHidden = true
            view.addSubview(errorStackView)
            errorStackView.addArrangedSubview(errorLabel)
            errorStackView.addArrangedSubview(errorButton)
            
            errorStackView.centerY()
            errorStackView.centerX()
            errorStackView.trailing(-30)
            errorStackView.leading(30)
            errorLabel.trailing()
            errorLabel.leading()
            errorButton.trailing()
            errorButton.leading()
            
            errorLabel.text = description
            errorButton.addTarget(self,
                                  action: #selector(reloadView),
                                  for: .touchUpInside)
            errorStackView.isHidden = false
            errorLabel.isHidden = false
            errorButton.isHidden = false
        }
    }
    
    func updateViewWithPhotoStatistics(viewModel: PhotoInfoViewModel) {
        DispatchQueue.main.async {
            self.photoViewModel = viewModel
            self.activityIndicator.isHidden = false
            self.image.kf.setImage(with: viewModel.image)
            self.nameLabel.text = "\(viewModel.authorName)"
            self.dateAndLocationLabel.text = "\(viewModel.date), \(viewModel.location)"
            self.downloadsLabel.text = "\(viewModel.dowloads)"
            if viewModel.isLiked {
                self.favoriteButton.setTitle("Убрать из избранного", for: .normal)
            } else {
                self.favoriteButton.setTitle("Добавить в избранное", for: .normal)
            }
            self.image.isHidden = false
            self.nameLabel.isHidden = false
            self.dateAndLocationLabel.isHidden = false
            self.downloadsLabel.isHidden = false
            self.activityIndicator.isHidden = true
            self.favoriteButton.isHidden = false
        }
    }  
}

//MARK: - Actions
extension PhotoInfoViewController {
    @objc
    private func likePhoto(){
        if photoViewModel?.isLiked == false {
            self.favoriteButton.setTitle("Убрать из избранного", for: .normal)
            photoViewModel?.isLiked = true
            output.likePhoto(key: photoViewModel?.id ?? "")
        } else {
            self.favoriteButton.setTitle("Добавить в избранное", for: .normal)
            photoViewModel?.isLiked = false
            output.unlikePhoto(key: photoViewModel?.id ?? "")
        }
    }
    @objc
    func reloadView() {
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
        output.viewDidLoad()
        errorStackView.isHidden = true
        errorLabel.isHidden = true
        errorButton.isHidden = true
    }
}

