//
//  PortfolioViewModel.swift
//  Baraka
//
//  Created by Snehal on 23/06/2025.
//
import UIKit
import RxSwift

class PortfolioViewModel {
    let portfolio = BehaviorSubject<Portfolio?>(value: nil)
    private let disposeBag = DisposeBag()

    func fetchData() {
        PortfolioService.shared.fetchPortfolio()
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] data in
                self?.portfolio.onNext(data)
            }, onError: { error in
                print("Error fetching portfolio: \(error)")
            }).disposed(by: disposeBag)
    }

    func startSimulatingPrices() {
        Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(portfolio.compactMap { $0 })
            .map { portfolio -> Portfolio in
                var updated = portfolio
                updated.positions = portfolio.positions.map { pos in
                    var position = pos
                    let randomFactor = Double.random(in: 0.9...1.1)
                    position.instrument.lastTradedPrice *= randomFactor
                    position.marketValue = position.quantity * position.instrument.lastTradedPrice
                    position.pnl = position.marketValue - position.cost
                    position.pnlPercentage = (position.pnl * 100) / position.cost
                    return position
                }
                updated.balance.netValue = updated.positions.reduce(0) { $0 + $1.marketValue }
                updated.balance.pnl = updated.positions.reduce(0) { $0 + $1.pnl }
                let totalCost = updated.positions.reduce(0) { $0 + $1.cost }
                updated.balance.pnlPercentage = (updated.balance.pnl * 100) / totalCost
                return updated
            }
            .bind(to: portfolio)
            .disposed(by: disposeBag)
    }
}
