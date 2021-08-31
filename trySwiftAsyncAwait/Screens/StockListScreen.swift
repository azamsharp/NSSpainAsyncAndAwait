//
//  StockListScreen.swift
//  StockListScreen
//
//  Created by Mohammad Azam on 8/22/21.
//

import SwiftUI

struct StockListScreen: View {
    
    @StateObject private var stockListVM = StockListViewModel(service: Webservice())
    
    var body: some View {
        NavigationView {
            VStack {
                
                List {
                    Section {
                        ForEach(stockListVM.stocks, id: \.symbol) { stock in
                            HStack {
                                Text(stock.symbol)
                                Spacer()
                                Text(String(format: "$%.2f", stock.price))
                            }
                        }
                    }
                    
                    Section {
                        ForEach(stockListVM.newsArticles, id: \.id) { article in
                            Text(article.title)
                        }
                    } header: {
                        Text("News")
                            .font(.headline)
                    }

                    
                }.listStyle(InsetGroupedListStyle())
                
                .navigationTitle("Stocks")
            }.task {
                
                await stockListVM.populate()
                //await stockListVM.populateStocks()
                //await stockListVM.populateTopNews()
            }
        }
    }
}

struct StockListScreen_Previews: PreviewProvider {
    static var previews: some View {
        StockListScreen()
    }
}
