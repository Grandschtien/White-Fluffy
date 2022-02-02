//
//  NetworkService.swift
//  WhiteAndFluffy
//
//  Created by Егор Шкарин on 30.01.2022.
//

import Foundation

enum RequestErrors: Error {
    case invalidURL
    case noInternetConnection
    case somethingWrong
}

protocol NetworkProtocol {
    func getPhotoData(completion: @escaping (Result<Data, Error>) -> ())
    func searchPhotos(query: String,
                      completion: @escaping (Result<Data, Error>) -> ())
    func getPhotoStatisticsForKey(key: String,
                                  completion: @escaping (Result<Data,Error>) -> ())
    func unlikePhoto(key: String)
    func likePhoto(key: String)
    func getLikedPhotos(completion: @escaping (Result<Data, Error>) -> ())
    func getPhotoForKey(key: String,
                        completion: @escaping (Result<Data,Error>) -> ()) 
}

final class NetworkService: NetworkProtocol {
    //MARK: - Функция получающая 20 случайных фото
    func getPhotoData(completion: @escaping (Result<Data, Error>) -> ()) {
        guard let url = URL.with(string: "photos/random?count=20") else {
            completion(.failure(RequestErrors.invalidURL))
            return
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue("Bearer \(authCode)", forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                completion(.failure(error))
            }
            guard let data = data else {
                completion(.failure(RequestErrors.noInternetConnection))
                return
            }
            if let response = response as? HTTPURLResponse, response.statusCode != 200 {
                completion(.failure(RequestErrors.somethingWrong))
            }
            completion(.success(data))
        }.resume()
    }
    //MARK: - Функция для поиска фото
    func searchPhotos(query: String, completion: @escaping (Result<Data, Error>) -> ()) {
        guard let url = URL.with(string: "search/photos?page=1&query=\(query)&lang=ru") else {
            return
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue("Bearer \(authCode)", forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            guard let data = data else {
                completion(.failure(RequestErrors.noInternetConnection))
                return
            }
            completion(.success(data))
        }.resume()
    }
    //MARK: - Функция получающая статистику по фото
    func getPhotoStatisticsForKey(key: String,
                                  completion: @escaping (Result<Data,Error>) -> ()) {
        guard let url = URL.with(string: "/photos/\(key)/statistics") else {
            return
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue("Client-ID \(apiKey)", forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            guard let data = data else {
                completion(.failure(RequestErrors.noInternetConnection))
                return
            }
            completion(.success(data))
        }.resume()
    }
    
    func getPhotoForKey(key: String,
                        completion: @escaping (Result<Data,Error>) -> ()) {
        guard let url = URL.with(string: "/photos/\(key)/") else {
            return
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue("Bearer \(authCode)", forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            guard let data = data else {
                completion(.failure(RequestErrors.noInternetConnection))
                return
            }
            completion(.success(data))
        }.resume()
    }
    //MARK: - Функция добавляющая фото в избранное
    func likePhoto(key: String) {
        guard let url = URL.with(string: "/photos/\(key)/like") else {
            return
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("Bearer \(authCode)", forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTask(with: urlRequest) { _, response, error in
            if let response = response as? HTTPURLResponse, response.statusCode != 201 {
                print(error?.localizedDescription ?? "")
            }
        }.resume()
    }
    //MARK: - Функция убирающая фото из избранного
    func unlikePhoto(key: String) {
        guard let url = URL.with(string: "/photos/\(key)/like") else {
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "DELETE"
        urlRequest.setValue("Bearer \(authCode)", forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTask(with: urlRequest) { _, response, error in
            if let response = response as? HTTPURLResponse, response.statusCode != 200 {
                print(error?.localizedDescription ?? "")
            }
        }.resume()
    }
    //MARK: - Функция получающая избранные фото
    func getLikedPhotos(completion: @escaping (Result<Data, Error>) -> ()) {
        guard let url = URL.with(string: "/users/\(userName)/likes") else {
            return
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.setValue("Bearer \(authCode)", forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                completion(.failure(error))
            }
            guard let data = data else {
                completion(.failure(RequestErrors.noInternetConnection))
                return
            }
            if let response = response as? HTTPURLResponse, response.statusCode != 200 {
                completion(.failure(RequestErrors.somethingWrong))
            }
            completion(.success(data))
        }.resume()
    }
}

extension URL {
    private static var baseUrl: String {
        return "https://api.unsplash.com/"
    }
    
    static func with(string: String) -> URL? {
        return URL(string: "\(baseUrl)\(string)")
    }
}
