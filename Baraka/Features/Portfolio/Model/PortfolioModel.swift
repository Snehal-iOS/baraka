//
//  PortfolioModel.swift
//  Baraka
//
//  Created by Snehal on 23/06/2025.
//

import UIKit
struct PortfolioModel: Decodable {
    let portfolio: Portfolio
}

struct Portfolio: Decodable {
    var balance: Balance
    var positions: [Position]
}

struct Balance: Decodable {
    var netValue: Double
    var pnl: Double
    var pnlPercentage: Double
}

struct Position: Decodable {
    var instrument: Instrument
    var quantity: Double
    var averagePrice: Double
    var cost: Double
    var marketValue: Double
    var pnl: Double
    var pnlPercentage: Double
}

struct Instrument: Decodable {
    var ticker: String
    var name: String
    var exchange: String
    var currency: String
    var lastTradedPrice: Double
}
