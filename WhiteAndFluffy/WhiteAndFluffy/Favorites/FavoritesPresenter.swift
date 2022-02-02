//
//  FavoritesPresenter.swift
//  WhiteAndFluffy
//
//  Created by Егор Шкарин on 29.01.2022.
//  
//

import Foundation

final class FavoritesPresenter: LikeProtocol{
    weak var view: FavoritesViewInput?
    weak var moduleOutput: FavoritesModuleOutput?
    
    private let router: FavoritesRouterInput
    private let interactor: FavoritesInteractorInput
    private let notificationCenter: NotificationCenter = NotificationCenter.default
    
    init(router: FavoritesRouterInput, interactor: FavoritesInteractorInput) {
        self.router = router
        self.interactor = interactor
        notificationCenter.addObserver(self,
                                       selector: #selector(newPhotoLiked),
                                       name: likeNotification,
                                       object: nil)
        notificationCenter.addObserver(self,
                                       selector: #selector(photoUnLiked),
                                       name: unLikeNotification,
                                       object: nil)
        
    }
}
//MARK: - FavoritesModuleInput
extension FavoritesPresenter: FavoritesModuleInput {
}
//MARK: - FavoritesViewOutput
extension FavoritesPresenter: FavoritesViewOutput {
    func addObeservers() {
        notificationCenter.addObserver(self,
                                       selector: #selector(newPhotoLiked),
                                       name: likeNotification,
                                       object: nil)
        notificationCenter.addObserver(self,
                                       selector: #selector(photoUnLiked),
                                       name: unLikeNotification,
                                       object: nil)
    }
    
    func removeObservers() {
        notificationCenter.removeObserver(likeNotification)
        notificationCenter.removeObserver(unLikeNotification)
    }
    
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
//MARK: - Notifications
extension FavoritesPresenter {
    @objc
    private func newPhotoLiked() {
        view?.photoWasLiked()
    }
    @objc
    private func photoUnLiked() {
        view?.photoWasUnLiked()
    }
}
