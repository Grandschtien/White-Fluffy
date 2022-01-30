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
}

final class NetworkService: NetworkProtocol {
    func getPhotoData(completion: @escaping (Result<Data, Error>) -> ()) {
        guard let url = URL.with(string: "photos/random?count=20") else {
            completion(.failure(RequestErrors.invalidURL))
            return
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue("Client-ID \(apiKey)", forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                completion(.failure(error))
            }
            guard let data = data else {
                completion(.failure(RequestErrors.noInternetConnection))
                return
            }
            completion(.success(data))
        }.resume()
    }
    
    func searchPhotos(query: String, completion: @escaping (Result<Data, Error>) -> ()) {
        guard let url = URL.with(string: "search/photos?page=1&query=\(query)") else {
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
    func getUserInfo() {
        guard let url = URL.with(string: "/me") else {
            return
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue("Client-ID \(apiKey)", forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            guard let data = data else {
                return
            }
            let json = try! JSONSerialization.jsonObject(with: data, options: [])
            print(json)
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
