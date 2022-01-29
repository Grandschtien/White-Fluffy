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
}

protocol PhotoInfoModuleOutput: AnyObject {
}

protocol PhotoInfoViewInput: AnyObject {
}

protocol PhotoInfoViewOutput: AnyObject {
}

protocol PhotoInfoInteractorInput: AnyObject {
}

protocol PhotoInfoInteractorOutput: AnyObject {
}

protocol PhotoInfoRouterInput: AnyObject {
}
