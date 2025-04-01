//
//  APIService.swift
//  SiriusProject
//
//  Created by Андрей Степанов on 29.03.2025.
//

import Foundation

enum APIError: Error {
    case urlSessionError(String)
    case serverError(String = "Server error")
    case invalidResponse(String = "Invalid response from server.")
    case decodingError(String = "Error parsing server response.")
}

protocol Service {
    func makeRequest<T: Codable>(with request: URLRequest, respModel: T.Type, log: @escaping Logging, completion: @escaping (T?, APIError?) -> Void)
}

class APIService: Service {
    let urlSession: URLSession

    init(urlSession: URLSession) {
        self.urlSession = urlSession
    }

    func makeRequest<T: Codable>(
        with request: URLRequest,
        respModel: T.Type,
        log: @escaping Logging = emptyLogging,
        completion: @escaping (T?, APIError?) -> Void
    ) {
        urlSession.dataTask(with: request) { data, resp, error in
            if let error = error {
                completion(nil, .urlSessionError(error.localizedDescription))
                return
            }

            if let resp = resp as? HTTPURLResponse, resp.statusCode != 200 && resp.statusCode != 201 {
                completion(nil, .serverError())
                return
            }

            guard let data = data else {
                completion(nil, .invalidResponse())
                return
            }

            do {
                let result = try JSONDecoder().decode(T.self, from: data)
                completion(result, nil)

            } catch let err {
                log(err.localizedDescription)
                completion(nil, .decodingError())
                return
            }
        }.resume()
    }
}
