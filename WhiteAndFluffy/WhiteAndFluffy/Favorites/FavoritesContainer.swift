//
//  FavoritesContainer.swift
//  WhiteAndFluffy
//
//  Created by Егор Шкарин on 29.01.2022.
//  
//

import UIKit

final class FavoritesContainer {
    let input: FavoritesModuleInput
	let viewController: UIViewController
	private(set) weak var router: FavoritesRouterInput!

	static func assemble(with context: FavoritesContext) -> FavoritesContainer {
        let router = FavoritesRouter()
        let interactor = FavoritesInteractor()
        let presenter = FavoritesPresenter(router: router, interactor: interactor)
		let viewController = FavoritesViewController(output: presenter)

		presenter.view = viewController
		presenter.moduleOutput = context.moduleOutput

		interactor.output = presenter

        return FavoritesContainer(view: viewController, input: presenter, router: router)
	}

    private init(view: UIViewController, input: FavoritesModuleInput, router: FavoritesRouterInput) {
		self.viewController = view
        self.input = input
		self.router = router
	}
}

struct FavoritesContext {
	weak var moduleOutput: FavoritesModuleOutput?
}
