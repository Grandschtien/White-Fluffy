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
    
	override func viewDidLoad() {
		super.viewDidLoad()
        setup()
	}
    
}
//MARK: - Настройка таблицы
extension FavoritesViewController {
    private func setup() {
        navigationController?.isNavigationBarHidden = false
        title = favoritesNavTitle
        table.dataSource = self
        table.delegate = self
        table.register(FavoritePhotoCell.self)
        view.addSubview(table)
        table.pins()
    }
}
//MARK: - FavoritesViewInput
extension FavoritesViewController: FavoritesViewInput {
}
//MARK: - UITableViewDataSource
extension FavoritesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueCell(cellType: FavoritePhotoCell.self, for: indexPath)
        cell.configure()
        return cell
    }
    
    
}

//MARK: - UITableViewDelegate
extension FavoritesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.height / 6
    }
}
