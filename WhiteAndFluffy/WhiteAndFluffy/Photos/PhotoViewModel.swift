//
//  PhotoViewModel.swift
//  WhiteAndFluffy
//
//  Created by Егор Шкарин on 30.01.2022.
//

import Foundation
import Kingfisher
struct PhotoViewModel {
    let id: String
    let resourceOfImage: ImageResource?
    let userName: String
    let location: String
    let likes: Int
    let date: String
    let isLiked: Bool
}
