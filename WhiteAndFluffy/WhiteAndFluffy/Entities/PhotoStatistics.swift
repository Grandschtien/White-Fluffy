//
//  PhotoStatistics.swift
//  WhiteAndFluffy
//
//  Created by Егор Шкарин on 30.01.2022.
//

import Foundation

struct Statistics: Decodable {
    let downloads: Downloads
}

struct Downloads: Decodable {
    let total: Int
}
