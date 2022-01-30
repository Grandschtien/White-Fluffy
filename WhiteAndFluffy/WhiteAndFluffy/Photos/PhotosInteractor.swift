//
//  PhotosInteractor.swift
//  WhiteAndFluffy
//
//  Created by Егор Шкарин on 29.01.2022.
//  
//

import Foundation

final class PhotosInteractor {
    weak var output: PhotosInteractorOutput?
    private let networkService: NetworkProtocol = NetworkService()
    
}
//MARK: - PhotosInteractorInput
extension PhotosInteractor: PhotosInteractorInput {
    /// Функция загрузки результатов поиска
    func startSearch(query: String) {
        networkService.searchPhotos(query: query) { [weak self] result in
            switch result {
            case .success(let data):
                guard let photos = try? JSONDecoder().decode(SearchResults.self,
                                                             from: data)
                else {
                    self?.output?.didCatchError(errorDescription: RequestErrors.somethingWrong.localizedDescription)
                    return
                }
                self?.output?.foundPhotos(photos: photos)
            case .failure(let error):
                self?.output?.didCatchError(errorDescription: error.localizedDescription)
            }
        }
    }
    /// Функция закгрузки фотографий
    func loadPhotos() {
        networkService.getPhotoData {[weak self] result in
            switch result {
            case .success(let data):
                guard let photos = try? JSONDecoder().decode([Photo].self,
                                                             from: data)
                else {
                    return
                }
                self?.output?.didLoadPhotos(photots: photos)
            case .failure(let error):
                self?.output?.didCatchError(errorDescription: error.localizedDescription)
            }
        }
    }
}
