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
    
    init(router: PhotoInfoRouterInput, interactor: PhotoInfoInteractorInput) {
        self.router = router
        self.interactor = interactor
    }
}

extension PhotoInfoPresenter: PhotoInfoModuleInput {
}

extension PhotoInfoPresenter: PhotoInfoViewOutput {
}

extension PhotoInfoPresenter: PhotoInfoInteractorOutput {
}
