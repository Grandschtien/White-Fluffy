//
//  PhotosViewController.swift
//  WhiteAndFluffy
//
//  Created by Егор Шкарин on 29.01.2022.
//  
//

import UIKit
import SkeletonView

final class PhotosViewController: UIViewController {
    private let output: PhotosViewOutput
    private var viewModels = [PhotoViewModel]()
    private var searchResultsViewModels: [PhotoViewModel] = []
    private let batchSize = 20
    private let collectionViewInsets =  UIEdgeInsets(top: 0,
                                                     left: 10,
                                                     bottom: 10,
                                                     right: 10)
    private var isFiltering: Bool {
        return !isSearchBarEmpty
    }
    private var isSearchBarEmpty: Bool {
        return searchBar.text?.isEmpty ?? true
    }
    private var searchBar = UISearchBar()
    private var numberOfPage = 1
    
    private var activityIndicator: UIActivityIndicatorView = {
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
            self.collection.reloadData()
        }
    }
    // MARK: - updateViewWithPhoto
    func updateViewWithPhoto(viewModels: [PhotoViewModel]) {
        DispatchQueue.main.async {
            self.viewModels.append(contentsOf: viewModels)
            self.collection.stopSkeletonAnimation()
            self.view.hideSkeleton(reloadDataAfter: true,
                                   transition: .none)
            self.collection.reloadData()
        }
    }
    
    //MARK: - setupErrorView
    func setupErrorView(with description: String) {
        DispatchQueue.main.async {[self] in
            if viewModels.isEmpty {
                view.addSubview(errorView)
                errorView.configureLayout()
                errorView.addTargetToErrorButton(self, action: #selector(reloadView), for: .touchUpInside)
                errorView.isHidden = false
                errorView.descriptionOfError = description
            } else {
                self.createAlertView(with: description)
            }
        }
    }
    
}
// MARK: - Настройка таблицы
extension PhotosViewController {
    private func setup() {
        navigationController?.isNavigationBarHidden = false
        navigationItem.titleView = searchBar
        view.backgroundColor = .white
        searchBar.placeholder = "Search photos"
        searchBar.delegate = self
        collection.dataSource = self
        collection.delegate = self
        collection.register(PhotoCell.self)
        collection.contentInset = collectionViewInsets
        view.addSubview(collection)
        collection.pins()
        collection.isSkeletonable = true
        collection.showAnimatedSkeleton()
        searchBar.searchTextField.keyboardType = .asciiCapable
    }
    
    private func createAlertView(with error: String) {
        let alertController = UIAlertController(title: "Error",
                                                message: error,
                                                preferredStyle: .alert)
        let action = UIAlertAction(title: "Refresh", style: .default) { action in
            DispatchQueue.main.async {
                self.reloadView()
            }
        }
        let oKaction = UIAlertAction(title: "Ok", style: .cancel)
        alertController.addAction(oKaction)
        alertController.addAction(action)
        present(alertController,
                animated: true,
                completion: nil)
        
    }
    
    //MARK: - setupWaitingIndicator
    private func setupWaitingIndicator() {
        view.addSubview(activityIndicator)
        activityIndicator.setup()
    }
}
//MARK: - UICollectionViewDataSource
extension PhotosViewController: SkeletonCollectionViewDataSource {
    func collectionSkeletonView(_ skeletonView: UICollectionView,
                                cellIdentifierForItemAt indexPath: IndexPath) ->
    ReusableCellIdentifier {
        return PhotoCell.reuseIdentifier
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isFiltering {
            return searchResultsViewModels.count
        } else {
            return viewModels.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("\(indexPath)")
        let cell = collectionView.dequeueCell(cellType: PhotoCell.self,
                                              for: indexPath)
        if isFiltering {
            if !searchResultsViewModels.isEmpty {
                cell.hideSkeleton()
            }
            cell.configure(with: searchResultsViewModels[indexPath.item])
            return cell
        } else {
            if !viewModels.isEmpty {
                cell.hideSkeleton()
            }
            if indexPath.row == (viewModels.count - 1) {
                let currentPage = viewModels.count / batchSize == 1 ? 2 : viewModels.count / batchSize
                output.loadNextPage(page: currentPage)
            }
            cell.configure(with: viewModels[indexPath.item])
            return cell
        }
    }
}
//MARK: - UITableViewDelegate
extension PhotosViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
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
            return CGSize(width: view.frame.width / 2 - 20,
                          height: view.frame.width / 2 - 20)
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
        output.viewDidLoad()
        errorView.isHidden = true
    }
}
