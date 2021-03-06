//
//  StockListViewModel.swift
//  StockListViewModel
//
//  Created by Mohammad Azam on 8/22/21.
//

import Foundation
import SwiftUI

@MainActor
class StockListViewModel: ObservableObject {
    
    @Published private(set) var stocks: [StockViewModel] = [StockViewModel]()
    @Published private(set) var newsArticles: [NewsArticleViewModel] = [NewsArticleViewModel]()
    let service: Webservice
    
    init(service: Webservice) {
        self.service = service
    }
    
    func populate() async {
        
        async let newsArticlesTask = Webservice().getLatestNews(url: Constants.Urls.newsURL)
        async let stocksTask = Webservice().getAllStocks(url: Constants.Urls.stocksURL)
        
        do {
            let articles = try await newsArticlesTask
            let stocks = try await stocksTask
            
            self.newsArticles = articles.map(NewsArticleViewModel.init)
            self.stocks = stocks.map(StockViewModel.init)
        }
        catch {
            print(error)
        }
    }
    
    func populateTopNews() async {
        
        do {
            let newsArticles = try await Webservice().getLatestNews(url: Constants.Urls.newsURL)
            DispatchQueue.main.async { [weak self] in
                self?.newsArticles = newsArticles.map(NewsArticleViewModel.init)
            }
        } catch {
            print(error)
        }
        
        /*
         Webservice().getLatestNews(url: Constants.Urls.newsURL) { result in
         switch result {
         case .success(let newsArticles):
         DispatchQueue.main.async { [weak self] in
         self?.newsArticles = newsArticles.map(NewsArticleViewModel.init)
         }
         case .failure(let error):
         print(error)
         }
         } */
    }
    
    
    func populateStocks() async {
        
        do {
            let stocks = try await Webservice().getAllStocks(url: Constants.Urls.stocksURL)
            self.stocks = stocks.map(StockViewModel.init)
        } catch {
            print(error)
        }
        
        /*
         Webservice().getAllStocks(url: Constants.Urls.stocksURL) { result in
         switch result {
         case .success(let stocks):
         DispatchQueue.main.async { [weak self] in
         print(stocks)
         self?.stocks = stocks.map(StockViewModel.init)
         }
         case .failure(let error):
         print(error)
         }
         } */
    }
}


struct StockViewModel {
    
    fileprivate let stock: Stock
    
    var symbol: String {
        stock.symbol
    }
    
    var description: String {
        stock.description
    }
    
    var price: Double {
        stock.price
    }
}


struct NewsArticleViewModel {
    
    fileprivate let newsArticle: NewsArticle
    
    let id = UUID()
    
    var title: String {
        newsArticle.title
    }
    
    var publication: String {
        newsArticle.publication
    }
    
    var imageURL: String {
        newsArticle.imageURL
    }
    
}
