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
    private var errorView: ErrorView = {
        var errorView = ErrorView(frame: .zero)
        errorView.translatesAutoresizingMaskIntoConstraints = false
        return errorView
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
        label.textAlignment = .center
        return label
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 30, weight: .heavy)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    private let downloadsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 20, weight: .light)
        label.textColor = .lightGray
        label.textAlignment = .center
        return label
    }()
    
    private let favoriteButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 10
        button.backgroundColor = UIColor(named: Colors.buttonColor.rawValue)
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
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        output.viewDidLoad()
        setup()
        setupWaitingIndicator()
    }
    override func viewWillDisappear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
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
        tabBarController?.tabBar.isHidden = true
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

        
        view.addSubview(dateAndLocationLabel)
        dateAndLocationLabel.leading(30)
        dateAndLocationLabel.trailing(-30)
        dateAndLocationLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor,
                                                  constant: 15).isActive = true
       
        
        view.addSubview(downloadsLabel)
        downloadsLabel.leading(30)
        downloadsLabel.trailing(-30)
        downloadsLabel.topAnchor.constraint(equalTo: dateAndLocationLabel.bottomAnchor,
                                                  constant: 15).isActive = true
                
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
            view.addSubview(errorView)
            errorView.configureLayout()
            errorView.addTargetToErrorButton(self, action: #selector(reloadView), for: .touchUpInside)
            errorView.isHidden = false
            errorView.descriptionOfError = description
        }
    }
    
    func updateViewWithPhotoStatistics(viewModel: PhotoInfoViewModel) {
        DispatchQueue.main.async {
            self.photoViewModel = viewModel
            self.activityIndicator.isHidden = false
            self.title = viewModel.authorName
            self.image.kf.setImage(with: viewModel.image, options: [.onlyFromCache, .cacheOriginalImage])
            self.nameLabel.text = "\(viewModel.authorName)"
            self.dateAndLocationLabel.text = "\(viewModel.date), \(viewModel.location)"
            self.downloadsLabel.text = "\(viewModel.dowloads)"
            if viewModel.isLiked {
                self.favoriteButton.setTitle(removeFromFavorites, for: .normal)
            } else {
                self.favoriteButton.setTitle(addToFavorites, for: .normal)
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
        guard let viewModel = photoViewModel else { return }
        if photoViewModel?.isLiked == false {
            self.favoriteButton.setTitle(removeFromFavorites, for: .normal)
            photoViewModel?.isLiked = true
            output.likePhoto(key: viewModel.id)
            output.likePhotoNotification(viewModel: viewModel)
        } else {
            self.favoriteButton.setTitle(addToFavorites, for: .normal)
            photoViewModel?.isLiked = false
            output.unlikePhoto(key: viewModel.id)
            output.unLikePhotoNotification(viewModel: viewModel)
        }
        
    }
    @objc
    func reloadView() {
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
        output.viewDidLoad()
        errorView.isHidden = false
    }
}

