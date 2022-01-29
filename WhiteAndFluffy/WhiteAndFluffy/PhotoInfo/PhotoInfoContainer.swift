//
//  PhotoInfoContainer.swift
//  WhiteAndFluffy
//
//  Created by Егор Шкарин on 29.01.2022.
//  
//

import UIKit

final class PhotoInfoContainer {
    let input: PhotoInfoModuleInput
	let viewController: UIViewController
	private(set) weak var router: PhotoInfoRouterInput!

	static func assemble(with context: PhotoInfoContext) -> PhotoInfoContainer {
        let router = PhotoInfoRouter()
        let interactor = PhotoInfoInteractor()
        let presenter = PhotoInfoPresenter(router: router, interactor: interactor)
		let viewController = PhotoInfoViewController(output: presenter)

		presenter.view = viewController
		presenter.moduleOutput = context.moduleOutput

		interactor.output = presenter

        return PhotoInfoContainer(view: viewController, input: presenter, router: router)
	}

    private init(view: UIViewController, input: PhotoInfoModuleInput, router: PhotoInfoRouterInput) {
		self.viewController = view
        self.input = input
		self.router = router
	}
}

struct PhotoInfoContext {
	weak var moduleOutput: PhotoInfoModuleOutput?
}
