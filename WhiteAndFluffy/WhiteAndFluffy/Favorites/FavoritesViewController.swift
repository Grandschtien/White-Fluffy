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
extension FavoritesViewController {
    private func setup() {
        navigationController?.isNavigationBarHidden = false
        title = favoritesNavTitle
        table.dataSource = self
        view.addSubview(table)
        table.pins()
    }
}
extension FavoritesViewController: FavoritesViewInput {
}

extension FavoritesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    
}
