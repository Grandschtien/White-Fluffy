//
//  FavoritesInteractor.swift
//  WhiteAndFluffy
//
//  Created by Егор Шкарин on 29.01.2022.
//  
//

import Foundation

final class FavoritesInteractor {
    weak var output: FavoritesInteractorOutput?
    private let networkService: NetworkProtocol = NetworkService()
}

extension FavoritesInteractor: FavoritesInteractorInput {
    func loadLikedPhotos() {
        networkService.getLikedPhotos {[weak self] result in
            switch result {
            case .success(let data):
                guard let photos = try? JSONDecoder().decode([Photo].self,
                                                             from: data)
                else {
                    self?.output?.didCatchError(errorDescription: RequestErrors.somethingWrong.localizedDescription)
                    return
                }
                self?.output?.didLoadLikedPhotos(photos: photos)
            case .failure(let error):
                self?.output?.didCatchError(errorDescription: error.localizedDescription)
            }
        }
    }
}


