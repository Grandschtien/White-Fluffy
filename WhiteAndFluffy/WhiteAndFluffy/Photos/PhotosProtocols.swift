//
//  PhotosProtocols.swift
//  WhiteAndFluffy
//
//  Created by Егор Шкарин on 29.01.2022.
//  
//

import Foundation

protocol PhotosModuleInput {
	var moduleOutput: PhotosModuleOutput? { get }
}

protocol PhotosModuleOutput: AnyObject {
    
}

protocol PhotosViewInput: AnyObject {
    func setupErrorView(with description: String)
    func updateViewWithPhoto(viewModels: [PhotoViewModel])
    func updateSearchResults(viewModels: [PhotoViewModel])
}

protocol PhotosViewOutput: AnyObject {
    func viewDidLoad()
    func search(query: String)
    func navigateToPhotoInfo(viewModel: PhotoViewModel)
}

protocol PhotosInteractorInput: AnyObject {
    func loadPhotos()
    func startSearch(query: String)
}

protocol PhotosInteractorOutput: AnyObject {
    func didCatchError(errorDescription: String)
    func didLoadPhotos(photots: [Photo])
    func foundPhotos(photos: SearchResults)
}

protocol PhotosRouterInput: AnyObject {
    func gotToPhotoInfo(viewModel: PhotoViewModel)
}
