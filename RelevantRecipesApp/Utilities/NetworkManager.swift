//
//  NetworkManager.swift
//  RelevantRecipesApp
//
//  Created by Сергеев Александр on 22.01.2024.
//

import Foundation
import Combine

class NetworkManager {
    
    enum NetworkingError: LocalizedError {
        case badURLResponse(url: URL)
        case unknow
        
        var errorDescription: String? {
            switch self {
            case .badURLResponse(url: let url):
                return "Bad response from url: \(url)"
            case .unknow:
                return "Unknown error occured"
            }
        }
    }
    
    static func download(url: URL) -> AnyPublisher<Data, Error> {
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { try handleURLResponse(output: $0, url: url) }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    static func handleURLResponse(output: URLSession.DataTaskPublisher.Output, url: URL) throws -> Data {
        guard let response = output.response as? HTTPURLResponse,
              response.statusCode >= 200 && response.statusCode < 300 else {
            throw NetworkingError.badURLResponse(url: url)
        }
        
        return output.data
    }
    
    static func handleCompletion(completion: Subscribers.Completion<Error>) {
        switch completion {
        case .finished:
            break
        case .failure(let error):
            print("Error: \(error.localizedDescription)")
        }
    }
    
}
