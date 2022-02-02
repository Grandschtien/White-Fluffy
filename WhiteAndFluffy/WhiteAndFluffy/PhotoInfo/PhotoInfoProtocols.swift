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
    func likePhotoNotification(viewModel: PhotoInfoViewModel)
    func unLikePhotoNotification(viewModel: PhotoInfoViewModel)
    func likePhoto(key: String)
    func unlikePhoto(key: String)
}

protocol PhotoInfoInteractorInput: AnyObject {
    func loadStatisticsOfPhoto(for key: String)
    func setLikedPhoto(key: String)
    func setUnlikedPhoto(key: String)
    func postLikePhotoNotification(viewModel: PhotoInfoViewModel)
    func postUnLikePhotoNotification(viewModel: PhotoInfoViewModel)
}

protocol PhotoInfoInteractorOutput: AnyObject {
    func recivePhotoStatistics(photo: PhotoWithStatistics)
    func didCatchError(errorDescription: String)
}

protocol PhotoInfoRouterInput: AnyObject {
}
