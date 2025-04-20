//
//  NetworkingManager.swift
//  Crypto
//
//  Created by Jethro Liu on 2025/04/20.
//

import Foundation
import Combine

class NetworkingManager {
    enum NetworkingError: LocalizedError {
        case badURLResponse(url: URLRequest)
        case badImageURLResponse(url: URL)
        case unknown
        
        var errorDescription: String? {
            switch self {
            case .badURLResponse(url: let url):
                return "[🔥] Bad response from URL. \(String(describing: url.url))"
            case .unknown:
                return "[⚠️] Unknown error occurred"
            case .badImageURLResponse(url: let url):
                return "[🔥] Bad response from Image URL. \(url)"
            }
        }
    }
    
    static func download(url: URLRequest) -> AnyPublisher<Data, any Error> {
        return URLSession.shared.dataTaskPublisher(for: url)
            .subscribe(on: DispatchQueue.global(qos: .default))
            .tryMap({ try handleURLResponse(output: $0, url: url)})
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    static func downloadImage(url: URL) -> AnyPublisher<Data, any Error> {
        return URLSession.shared.dataTaskPublisher(for: url)
            .subscribe(on: DispatchQueue.global(qos: .default))
            .tryMap({ try handleImageURLResponse(output: $0, url: url)})
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    static func handleCompletion(_ completion: Subscribers.Completion<Error>) {
        switch completion {
        case .failure(let error):
            print("Failed to fetch data: \(error.localizedDescription)")
        case .finished:
            break
        }
    }
    
    private static func handleURLResponse(output: URLSession.DataTaskPublisher.Output, url: URLRequest) throws -> Data {
        guard let response = output.response as? HTTPURLResponse,
              response.statusCode >= 200 && response.statusCode < 300 else {
            throw NetworkingError.badURLResponse(url: url)
        }
        
        return output.data
    }
    
    private static func handleImageURLResponse(output: URLSession.DataTaskPublisher.Output, url: URL) throws -> Data {
        guard let response = output.response as? HTTPURLResponse,
              response.statusCode >= 200 && response.statusCode < 300 else {
            throw NetworkingError.badImageURLResponse(url: url)
        }
        
        return output.data
    }
}
