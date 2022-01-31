//
//  Photos.swift
//  WhiteAndFluffy
//
//  Created by Егор Шкарин on 30.01.2022.
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let photo = try? newJSONDecoder().decode(Photo.self, from: jsonData)

import Foundation

// MARK: - PhotoElement
struct Photo: Decodable {
    let id: String
    let createdAt: String?
    let photoDescription: String?
    let urls: Urls
    let likedByUser: Bool
    let likes: Int?
    let user: User?

    enum CodingKeys: String, CodingKey {
        case id
        case createdAt = "created_at"
        case photoDescription = "description"
        case urls
        case likedByUser = "liked_by_user"
        case likes
        case user
    }
}

// MARK: - User
struct User: Decodable {
    let id: String
    let username: String
    let name: String
    let firstName: String
    let lastName : String?
    let bio: String?
    let location: String?

    enum CodingKeys: String, CodingKey {
        case id
        case username, name
        case firstName = "first_name"
        case lastName = "last_name"
        case bio, location
    }
}
// MARK: - Urls
struct Urls: Codable {
    let raw, full, regular, small: String
    let thumb: String
}
