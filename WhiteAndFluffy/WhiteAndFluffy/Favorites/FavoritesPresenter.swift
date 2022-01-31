//
//  FavoritesPresenter.swift
//  WhiteAndFluffy
//
//  Created by Егор Шкарин on 29.01.2022.
//  
//

import Foundation

final class FavoritesPresenter {
	weak var view: FavoritesViewInput?
    weak var moduleOutput: FavoritesModuleOutput?
    
	private let router: FavoritesRouterInput
	private let interactor: FavoritesInteractorInput
    
    init(router: FavoritesRouterInput, interactor: FavoritesInteractorInput) {
        self.router = router
        self.interactor = interactor
    }
}
//MARK: - FavoritesModuleInput
extension FavoritesPresenter: FavoritesModuleInput {
}
//MARK: - FavoritesViewOutput
extension FavoritesPresenter: FavoritesViewOutput {
    func navigateToPhotoInfo(viewModel: PhotoViewModel) {
        router.gotToPhotoInfo(viewModel: viewModel)
    }
    
    func viewDidLoad() {
        interactor.loadLikedPhotos()
    }
}
//MARK: - FavoritesInteractorOutput
extension FavoritesPresenter: FavoritesInteractorOutput {
    func didCatchError(errorDescription: String) {
        view?.setupErrorView(with: errorDescription)
    }
    
    func didLoadLikedPhotos(photos: [Photo]) {
        let viewModels = makeViewModels(photos: photos).compactMap { viewModel in
            return viewModel
        }
        view?.updateViewsWithLikedPhotos(viewModels: viewModels)
    }
}

extension FavoritesPresenter {
    func makeViewModels(photos: [Photo]) -> [PhotoViewModel?] {
        return photos.map { photo in
            guard let url = URL(string: photo.urls.regular) else  {
                return nil
            }
            let id = photo.id
            let resource = KingFisherManager.setupResourceForCache(url: url)
            let userName = photo.user?.username
            let location = photo.user?.location
            let likes = photo.likes
            let date = photo.createdAt
            let isLiked = photo.likedByUser
            return PhotoViewModel(id: id, resourceOfImage: resource,
                                  userName: userName ?? noUserName,
                                  location: location ?? noLocation,
                                  likes: likes ?? 0,
                                  date: date ?? noDate,
                                  isLiked: isLiked)
        }
    }
}
