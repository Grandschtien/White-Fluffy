//
//  FavoritesViewController.swift
//  WhiteAndFluffy
//
//  Created by Егор Шкарин on 29.01.2022.
//  
//

import UIKit

final class FavoritesViewController: UIViewController {
	private let output: FavoritesViewOutput
    var viewModels = [PhotoViewModel]()
    
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
    
    private let table: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.separatorStyle = .none
        return table
    }()
    init(output: FavoritesViewOutput) {
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
        setupWaitingIndicator()
        setup()
	}
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        output.removeObservers()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        output.removeObservers()
    }
}
//MARK: - Настройка таблицы
extension FavoritesViewController {
    private func setup() {
        view.backgroundColor = .white
        title = favoritesNavTitle
        table.dataSource = self
        table.delegate = self
        table.register(FavoritePhotoCell.self)
        view.addSubview(table)
        table.pins()
    }
    //MARK: - setupWaitingIndicator
    private func setupWaitingIndicator() {
        view.addSubview(activityIndicator)
        activityIndicator.setup()
    }
}
//MARK: - FavoritesViewInput
extension FavoritesViewController: FavoritesViewInput {
    func photoWasLiked() {
        table.isHidden = true
        reloadView()
    }
    
    func photoWasUnLiked() {
        table.isHidden = true
        reloadView()
    }
    
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
    
    func updateViewsWithLikedPhotos(viewModels: [PhotoViewModel]) {
        DispatchQueue.main.async {
            self.viewModels = viewModels
            self.activityIndicator.isHidden = true
            self.table.isHidden = false
            self.table.reloadData()
        }
    }
    
}
//MARK: - UITableViewDataSource
extension FavoritesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueCell(cellType: FavoritePhotoCell.self, for: indexPath)
        cell.configure(viewModel: viewModels[indexPath.row])
        return cell
    }
    
    
}

//MARK: - UITableViewDelegate
extension FavoritesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.height / 6
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        output.navigateToPhotoInfo(viewModel: viewModels[indexPath.row])
    }
}
//MARK: - Actions
extension FavoritesViewController {
    @objc
    func reloadView() {
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
        output.viewDidLoad()
        errorView.isHidden = false
    }
}
