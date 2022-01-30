//
//  PhotosRouter.swift
//  WhiteAndFluffy
//
//  Created by Егор Шкарин on 29.01.2022.
//  
//

import UIKit

final class PhotosRouter {
    var viewController: UIViewController?
}

extension PhotosRouter: PhotosRouterInput {
    func gotToPhotoInfo(viewModel: PhotoViewModel) {
        let photoInfoContext = PhotoInfoContext(moduleOutput: nil)
        let photoIfoContainer = PhotoInfoContainer.assemble(with: photoInfoContext)
        photoIfoContainer.input.recivePhoto(viewModel: viewModel)
        viewController?.navigationController?.pushViewController(photoIfoContainer.viewController,
                                                                 animated: true)
    }
}
