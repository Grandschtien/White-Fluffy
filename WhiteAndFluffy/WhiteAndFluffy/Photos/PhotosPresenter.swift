//
//  PhotosPresenter.swift
//  WhiteAndFluffy
//
//  Created by Егор Шкарин on 29.01.2022.
//  
//

import Foundation

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

extension PhotosPresenter: PhotosModuleInput {
}

extension PhotosPresenter: PhotosViewOutput {
}

extension PhotosPresenter: PhotosInteractorOutput {
}
