//
//  Stock.swift
//  Stock
//
//  Created by Mohammad Azam on 8/20/21.
//

import Foundation

struct Stock: Decodable {
    let symbol: String
    let description: String
    let price: Double 
}
