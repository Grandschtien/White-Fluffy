//
//  PhotoInfoProtocols.swift
//  WhiteAndFluffy
//
//  Created by Егор Шкарин on 29.01.2022.
//  
//

import Foundation

protocol PhotoInfoModuleInput {
	var moduleOutput: PhotoInfoModuleOutput? { get }
    func recivePhoto(viewModel: PhotoViewModel)
}

protocol PhotoInfoModuleOutput: AnyObject {
}

protocol PhotoInfoViewInput: AnyObject {
    func updateViewWithPhotoStatistics(viewModel: PhotoInfoViewModel)
    func setupErrorView(with description: String)
}

protocol PhotoInfoViewOutput: AnyObject {
    func viewDidLoad()
}

protocol PhotoInfoInteractorInput: AnyObject {
    func loadStatisticsOfPhoto(for key: String)
}

protocol PhotoInfoInteractorOutput: AnyObject {
    func recivePhotoStatistics(photo: Statistics)
    func didCatchError(errorDescription: String)
}

protocol PhotoInfoRouterInput: AnyObject {
}
