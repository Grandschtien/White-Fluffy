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
    private let table: UITableView = {
        var table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.backgroundColor = .white
        return table
    }()
    
    init(output: PhotosViewOutput) {
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
//MARK: - PhotosViewInput
extension PhotosViewController: PhotosViewInput {
}
// MARK: - Настройка таблицы 
extension PhotosViewController {
    private func setup() {
        navigationController?.isNavigationBarHidden = false
        title = photosNavTitle
        table.dataSource = self
        view.addSubview(table)
        table.pins()
    }
}
//MARK: - UITableViewDataSource
extension PhotosViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
//MARK: - UITableViewDelegate
extension PhotosViewController: UITableViewDelegate {
    
}
