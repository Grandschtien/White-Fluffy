//
//  SearchResults.swift
//  WhiteAndFluffy
//
//  Created by Егор Шкарин on 30.01.2022.
//

import Foundation

struct SearchResults: Decodable {
    let total: Int
    let total_pages: Int
    let results: [Photo]
}
