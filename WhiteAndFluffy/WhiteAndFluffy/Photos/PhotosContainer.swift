//
//  PhotosContainer.swift
//  WhiteAndFluffy
//
//  Created by Егор Шкарин on 29.01.2022.
//  
//

import UIKit

final class PhotosContainer {
    let input: PhotosModuleInput
	let viewController: UIViewController
	private(set) weak var router: PhotosRouterInput!

	static func assemble(with context: PhotosContext) -> PhotosContainer {
        let router = PhotosRouter()
        let interactor = PhotosInteractor()
        let presenter = PhotosPresenter(router: router, interactor: interactor)
		let viewController = PhotosViewController(output: presenter)

		presenter.view = viewController
		presenter.moduleOutput = context.moduleOutput

		interactor.output = presenter

        return PhotosContainer(view: viewController, input: presenter, router: router)
	}

    private init(view: UIViewController, input: PhotosModuleInput, router: PhotosRouterInput) {
		self.viewController = view
        self.input = input
		self.router = router
	}
}

struct PhotosContext {
	weak var moduleOutput: PhotosModuleOutput?
}
