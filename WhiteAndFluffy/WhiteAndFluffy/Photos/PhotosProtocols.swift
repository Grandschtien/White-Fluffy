//
//  PhotosProtocols.swift
//  WhiteAndFluffy
//
//  Created by Егор Шкарин on 29.01.2022.
//  
//

import Foundation

protocol PhotosModuleInput {
	var moduleOutput: PhotosModuleOutput? { get }
}

protocol PhotosModuleOutput: AnyObject {
}

protocol PhotosViewInput: AnyObject {
}

protocol PhotosViewOutput: AnyObject {
}

protocol PhotosInteractorInput: AnyObject {
}

protocol PhotosInteractorOutput: AnyObject {
}

protocol PhotosRouterInput: AnyObject {
}
