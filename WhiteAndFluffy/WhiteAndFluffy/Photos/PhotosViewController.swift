//
//  PhotosViewController.swift
//  WhiteAndFluffy
//
//  Created by Егор Шкарин on 29.01.2022.
//  
//

import UIKit

final class PhotosViewController: UIViewController {
    private let output: PhotosViewOutput
    private var viewModels = [PhotoViewModel]()
    private var searchResultsViewModels: [PhotoViewModel] = []
    
    private var isFiltering: Bool {
        return !isSearchBarEmpty
    }
    private var isSearchBarEmpty: Bool {
            return searchBar.text?.isEmpty ?? true
        }
    private var searchBar = UISearchBar()
    private var activityIndicator: UIActivityIndicatorView = {
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
        button.setTitleColor(UIColor(named: Colors.buttonColor.rawValue), for: .normal)
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(named: Colors.buttonColor.rawValue)?.cgColor
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
    private let collection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        var collection = UICollectionView(frame: .zero,
                                          collectionViewLayout: layout)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.backgroundColor = .white
        return collection
    }()
    
    
    init(output: PhotosViewOutput) {
        self.output = output
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        output.viewDidLoad()
        setupWaitingIndicator()
    }
}
//MARK: - PhotosViewInput
extension PhotosViewController: PhotosViewInput {
    //MARK: - updateSearchResults
    func updateSearchResults(viewModels: [PhotoViewModel]) {
        DispatchQueue.main.async {
            self.searchResultsViewModels = viewModels
            if self.searchResultsViewModels.count == 0 {
                self.searchResultsViewModels = []
                return
            }
            self.collection.isHidden = false
            self.activityIndicator.isHidden = true
            self.collection.reloadData()
        }
    }
    // MARK: - updateViewWithPhoto
    func updateViewWithPhoto(viewModels: [PhotoViewModel]) {
        DispatchQueue.main.async {
            self.collection.isHidden = false
            self.activityIndicator.isHidden = true
            self.viewModels = viewModels
            self.collection.reloadData()
        }
    }
    
    //MARK: - setupErrorView
    func setupErrorView(with description: String) {
        DispatchQueue.main.async {[self] in
            collection.isHidden = true
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
    
}
// MARK: - Настройка таблицы
extension PhotosViewController {
    private func setup() {
        collection.isHidden = true
        navigationController?.isNavigationBarHidden = false
        navigationItem.titleView = searchBar
        view.backgroundColor = .white
        searchBar.placeholder = "Search photos"
        searchBar.delegate = self
        collection.dataSource = self
        collection.delegate = self
        collection.register(PhotoCell.self)
        collection.contentInset = UIEdgeInsets(top: 0,
                                               left: 10,
                                               bottom: 10,
                                               right: 10)
        view.addSubview(collection)
        collection.pins()
        searchBar.searchTextField.addTarget(self, action: #selector(removeRuCharacters(_:)), for: .editingChanged)
    }
    
    //MARK: - setupWaitingIndicator
    private func setupWaitingIndicator() {
        view.addSubview(activityIndicator)
        activityIndicator.setup()
    }
}
//MARK: - UITableViewDataSource
extension PhotosViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        if isFiltering {
            return searchResultsViewModels.count
        } else {
            return viewModels.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collection.dequeueCell(cellType: PhotoCell.self,
                                          for: indexPath)
        if isFiltering {
            cell.configure(with: searchResultsViewModels[indexPath.item])
        } else {
            cell.configure(with: viewModels[indexPath.item])
        }
        return cell
    }
}
//MARK: - UITableViewDelegate
extension PhotosViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        if isFiltering {
            output.navigateToPhotoInfo(viewModel: searchResultsViewModels[indexPath.item])
        } else {
            output.navigateToPhotoInfo(viewModel: viewModels[indexPath.item])
        }
    }
   
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchBar.endEditing(true)
    }
}
//MARK: - UICollectionViewDelegateFlowLayout
extension PhotosViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width / 2 - 20, height: view.frame.width / 2 - 20)
    }
}

//MARK: - UISearchBarDelegate
extension PhotosViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            collection.reloadData()
        }
        output.search(query: searchText)
    }
}
//MARK: - Actions
extension PhotosViewController {
    @objc
    func reloadView() {
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
        output.viewDidLoad()
        errorStackView.isHidden = true
        errorLabel.isHidden = true
        errorButton.isHidden = true
    }
    
    @objc
    func removeRuCharacters(_ sender: UISearchTextField) {
        guard let text = sender.text else { return }
        let ruCharacters = ruCharacters
        sender.text = text.filter({ char in
            if ruCharacters.contains(char) {
                return false
            }
            return true
        })
    }
}
