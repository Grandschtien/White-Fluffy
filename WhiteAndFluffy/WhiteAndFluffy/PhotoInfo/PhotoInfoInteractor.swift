//
//  PhotoInfoInteractor.swift
//  WhiteAndFluffy
//
//  Created by Егор Шкарин on 29.01.2022.
//  
//

import Foundation

final class PhotoInfoInteractor: LikeProtocol {
    weak var output: PhotoInfoInteractorOutput?
    private let networkService: NetworkProtocol = NetworkService()
    private let notificationcenter: NotificationCenter = NotificationCenter.default
}

extension PhotoInfoInteractor: PhotoInfoInteractorInput {
    func postLikePhotoNotification(viewModel: PhotoInfoViewModel) {
        notificationcenter.post(name: likeNotification, object: nil)
    }
    
    func postUnLikePhotoNotification(viewModel: PhotoInfoViewModel) {
        notificationcenter.post(name: unLikeNotification, object: nil)
    }
    
    func setLikedPhoto(key: String) {
        networkService.likePhoto(key: key)
    }
    
    func setUnlikedPhoto(key: String) {
        networkService.unlikePhoto(key: key)
    }
    
    func loadStatisticsOfPhoto(for key: String) {
        networkService.getPhotoStatisticsForKey(key: key) {[weak self] result in
            switch result {
            case .success(let data):
                guard let statistics = try? JSONDecoder().decode(Statistics.self, from: data) else {
                    self?.output?.didCatchError(errorDescription: RequestErrors.somethingWrong.localizedDescription)
                    return
                }
                self?.networkService.getPhotoForKey(key: key) { result in
                    switch result {
                    case .success(let data):
                        guard let photo = try? JSONDecoder().decode(Photo.self, from: data) else {
                            self?.output?.didCatchError(errorDescription: RequestErrors.somethingWrong.localizedDescription)
                            return
                        }
                        let photoWhiStatistics = PhotoWithStatistics(isLikedByUser: photo.likedByUser, statistics: statistics)
                        self?.output?.recivePhotoStatistics(photo: photoWhiStatistics)
                    case .failure(let error):
                        self?.output?.didCatchError(errorDescription: error.localizedDescription)
                    }
                }
            case .failure(let error):
                self?.output?.didCatchError(errorDescription: error.localizedDescription)
            }
        }
    }
}
