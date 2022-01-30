//
//  PhotosPresenter.swift
//  WhiteAndFluffy
//
//  Created by Егор Шкарин on 29.01.2022.
//  
//

import Foundation
import Kingfisher

final class PhotosPresenter {
	weak var view: PhotosViewInput?
    weak var moduleOutput: PhotosModuleOutput?
    
	private let router: PhotosRouterInput
	private let interactor: PhotosInteractorInput
    
    init(router: PhotosRouterInput, interactor: PhotosInteractorInput) {
        self.router = router
        self.interactor = interactor
    }
}
//MARK: - PhotosModuleInput
extension PhotosPresenter: PhotosModuleInput {
}
//MARK: - PhotosViewOutput
extension PhotosPresenter: PhotosViewOutput {
    func navigateToPhotoInfo(viewModel: PhotoViewModel) {
        router.gotToPhotoInfo(viewModel: viewModel)
    }
    
    func search(query: String) {
        interactor.startSearch(query: query)
    }
    
    func viewDidLoad() {
        interactor.loadPhotos()
    }
}
//MARK: - PhotosInteractorOutput
extension PhotosPresenter: PhotosInteractorOutput {
    
    func foundPhotos(photos: SearchResults) {
        let viewModels = makeSearchedViewModels(photos: photos).compactMap { viewModel in
            return viewModel
        }
        view?.updateSearchResults(viewModels: viewModels)
    }
    
    func didCatchError(errorDescription: String) {
        view?.setupErrorView(with: errorDescription)
    }
    
    func didLoadPhotos(photots: [Photo]) {
        let viewModels = makeViewModels(photos: photots).compactMap { viewModel in
            return viewModel
        }
        view?.updateViewWithPhoto(viewModels: viewModels)
    }
}
//MARK: - Создание viewModels
extension PhotosPresenter {
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
                                  userName: userName ?? "Нет имени пользователя",
                                  location: location ?? "Местоположение неизвестно",
                                  likes: likes ?? 0,
                                  date: date ?? "Дата неизвестна",
                                  isLiked: isLiked)
        }
    }
    func makeSearchedViewModels(photos: SearchResults) -> [PhotoViewModel?] {
        return photos.results.map { photo in
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
                                  userName: userName ?? "Нет имени пользователя",
                                  location: location ?? "Местоположение неизвестно",
                                  likes: likes ?? 0,
                                  date: date ?? "Дата неизвестна",
                                  isLiked: isLiked)
        }
    }
}
