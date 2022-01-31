//
//  PhotoInfoInteractor.swift
//  WhiteAndFluffy
//
//  Created by Егор Шкарин on 29.01.2022.
//  
//

import Foundation

final class PhotoInfoInteractor {
	weak var output: PhotoInfoInteractorOutput?
    private let networkService: NetworkProtocol = NetworkService()
}

extension PhotoInfoInteractor: PhotoInfoInteractorInput {
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
                self?.output?.recivePhotoStatistics(photo: statistics)
            case .failure(let error):
                self?.output?.didCatchError(errorDescription: error.localizedDescription)
            }
        }
    }
}
