//
//  PortfolioNetworkService.swift
//  Baraka
//
//  Created by Snehal on 23/06/2025.
//

import UIKit
import RxSwift
import RxCocoa
import Foundation

class PortfolioService {
    static let shared = PortfolioService()
    private init() {}

    func fetchPortfolio() -> Observable<Portfolio> {
        let url = URL(string: "https://dummyjson.com/c/60b7-70a6-4ee3-bae8")!
        return URLSession.shared.rx.data(request: URLRequest(url: url))
            .map { try JSONDecoder().decode(PortfolioModel.self, from: $0).portfolio }
    }
}
