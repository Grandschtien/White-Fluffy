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
    func viewDidLoad() {
        
    }
}
//MARK: - FavoritesInteractorOutput
extension FavoritesPresenter: FavoritesInteractorOutput {
    
}
