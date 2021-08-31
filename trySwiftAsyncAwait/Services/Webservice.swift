//
//  Webservice.swift
//  Webservice
//
//  Created by Mohammad Azam on 8/22/21.
//

import Foundation

enum NetworkError: Error {
    case badURL
    case decodingError
    case badRequest
}

class Webservice {

    
    func getLatestNews(url: URL, completion: @escaping (Result<[NewsArticle], NetworkError>) -> Void) {
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            guard let data = data,
                  (response as? HTTPURLResponse)?.statusCode == 200,
                  error == nil else {
                      completion(.failure(.badRequest))
                      return
            }
            
            let newsArticles = try? JSONDecoder().decode([NewsArticle].self, from: data)
            completion(.success(newsArticles ?? []))
            
        }.resume()
        
    }
    
    
    func getLatestNews(url: URL) async throws -> [NewsArticle] {
        
        return try await withCheckedThrowingContinuation { continuation in
            getLatestNews(url: Constants.Urls.newsURL) { result in
                switch result {
                    case .success(let newsArticles):
                        continuation.resume(returning: newsArticles)
                    case .failure(let error):
                        continuation.resume(throwing: error)
                }
            }
        }
        
    }
    
    
    
    func getAllStocks(url: URL) async throws -> [Stock] {
        let (data, response) = try await URLSession.shared.data(from: url)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else { throw NetworkError.badRequest }
        let stocks = try? JSONDecoder().decode([Stock].self, from: data)
        return stocks ?? []
    }
    
    
    func getAllStocks(url: URL, completion: @escaping (Result<[Stock], NetworkError>) -> Void) {
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            guard let data = data,
                  (response as? HTTPURLResponse)?.statusCode == 200,
                  error == nil else {
                      completion(.failure(.badRequest))
                      return
            }
            
            let stocks = try? JSONDecoder().decode([Stock].self, from: data)
            completion(.success(stocks ?? []))
        }.resume()
        
    }
    
}
