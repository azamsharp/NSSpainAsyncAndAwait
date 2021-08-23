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
