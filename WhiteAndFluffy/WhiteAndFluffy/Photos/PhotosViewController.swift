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
    private let collection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        var collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
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
        collection.dataSource = self
        collection.delegate = self
        collection.register(PhotoCell.self)
        collection.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10)
        view.addSubview(collection)
        collection.pins()
    }
}
//MARK: - UITableViewDataSource
extension PhotosViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        100
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collection.dequeueCell(cellType: PhotoCell.self, for: indexPath)
        let data = Data()
        cell.configure(with: data)
        return cell
    }
}
//MARK: - UITableViewDelegate
extension PhotosViewController: UICollectionViewDelegate {

}
//MARK: - UICollectionViewDelegateFlowLayout
extension PhotosViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width / 2 - 20, height: view.frame.width / 2 - 20)
    }
}
