//
//  FavoritesProtocols.swift
//  WhiteAndFluffy
//
//  Created by Егор Шкарин on 29.01.2022.
//  
//

import Foundation

protocol FavoritesModuleInput {
	var moduleOutput: FavoritesModuleOutput? { get }
}

protocol FavoritesModuleOutput: AnyObject {
}

protocol FavoritesViewInput: AnyObject {
    func setupErrorView(with description: String)
    func updateViewsWithLikedPhotos(viewModels: [PhotoViewModel])
    func photoWasLiked()
    func photoWasUnLiked()
}

protocol FavoritesViewOutput: AnyObject, ViewOutput {
    func navigateToPhotoInfo(viewModel: PhotoViewModel)
    func addObeservers()
    func removeObservers()
}

protocol FavoritesInteractorInput: AnyObject {
    func loadLikedPhotos()
}

protocol FavoritesInteractorOutput: AnyObject {
    func didCatchError(errorDescription: String)
    func didLoadLikedPhotos(photos: [Photo])
}

protocol FavoritesRouterInput: AnyObject {
    func gotToPhotoInfo(viewModel: PhotoViewModel)
}
