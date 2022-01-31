//
//  PhotoInfoViewModel.swift
//  WhiteAndFluffy
//
//  Created by Егор Шкарин on 30.01.2022.
//

import Foundation
import Kingfisher

struct PhotoInfoViewModel {
    let id: String
    let image: ImageResource?
    let authorName: String
    let date: String
    let location: String
    let dowloads: String
    var isLiked: Bool
}
