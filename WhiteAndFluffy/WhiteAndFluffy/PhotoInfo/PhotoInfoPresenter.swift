//
//  PhotoInfoPresenter.swift
//  WhiteAndFluffy
//
//  Created by Егор Шкарин on 29.01.2022.
//  
//

import Foundation

final class PhotoInfoPresenter {
	weak var view: PhotoInfoViewInput?
    weak var moduleOutput: PhotoInfoModuleOutput?
    
	private let router: PhotoInfoRouterInput
	private let interactor: PhotoInfoInteractorInput
    private var photoViewModel: PhotoViewModel?
    
    init(router: PhotoInfoRouterInput, interactor: PhotoInfoInteractorInput) {
        self.router = router
        self.interactor = interactor
    }
}
// MARK: - PhotoInfoModuleInput
extension PhotoInfoPresenter: PhotoInfoModuleInput {
    func recivePhoto(viewModel: PhotoViewModel) {
        self.photoViewModel = viewModel
    }
}
// MARK: - PhotoInfoViewOutput
extension PhotoInfoPresenter: PhotoInfoViewOutput {
    func likePhoto(key: String) {
        interactor.setLikedPhoto(key: key)
    }
    
    func unlikePhoto(key: String) {
        interactor.setUnlikedPhoto(key: key)
    }
    func viewDidLoad() {
        interactor.loadStatisticsOfPhoto(for: photoViewModel?.id ?? "")
    }
}
// MARK: - PhotoInfoInteractorOutput
extension PhotoInfoPresenter: PhotoInfoInteractorOutput {
    func didCatchError(errorDescription: String) {
        view?.setupErrorView(with: errorDescription)
    }
    func recivePhotoStatistics(photo: Statistics) {
       let viewModel = makeViewModel(statistics: photo)
        view?.updateViewWithPhotoStatistics(viewModel: viewModel)
    }
}
//MARK: - Создание viewModels
extension PhotoInfoPresenter {
    private func makeViewModel(statistics: Statistics) -> PhotoInfoViewModel {
        let id = photoViewModel?.id ?? ""
        let image = photoViewModel?.resourceOfImage
        let authorName = photoViewModel?.userName ?? noUserName
        let date = photoViewModel?.date.dropLast(15) ?? noDate.compactMap{$0}
        let location = photoViewModel?.location ?? noLocation
        let downloads = "Кол-во скачиваний \(statistics.downloads.total)"
        let isLiked = photoViewModel?.isLiked ?? false
        return PhotoInfoViewModel(id: id,
                                  image: image,
                                  authorName: authorName,
                                  date: String(date),
                                  location: location,
                                  dowloads: downloads,
                                  isLiked: isLiked)
    }
}
