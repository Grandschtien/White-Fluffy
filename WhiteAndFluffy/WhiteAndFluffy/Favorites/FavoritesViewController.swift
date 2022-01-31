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
    
    private let table: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
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
        setupWaitingIndicator()
        setup()
	}
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        table.isHidden = true
        reloadView()
    }
}
//MARK: - Настройка таблицы
extension FavoritesViewController {
    private func setup() {
        view.backgroundColor = .white
        title = favoritesNavTitle
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.backgroundColor = .white
        table.dataSource = self
        table.delegate = self
        table.separatorStyle = .none
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
        errorStackView.isHidden = true
        errorLabel.isHidden = true
        errorButton.isHidden = true
    }
}
