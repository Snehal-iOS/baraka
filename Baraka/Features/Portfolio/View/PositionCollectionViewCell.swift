//
//  PositionCollectionViewCell.swift
//  Baraka
//
//  Created by Snehal on 24/06/2025.
//
import UIKit

class PositionCell: UICollectionViewCell {
    static let reuseId = "PositionCell"

    private let containerView = UIView()
    private let statusDot = UIView()
    private let tickerLabel = UILabel()
    private let nameLabel = UILabel()
    private let pnlAmountLabel = UILabel()
    private let pnlPercentageLabel = PaddingLabel()

    override init(frame: CGRect) {
        super.init(frame: frame)

        // Container View
        contentView.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])

        containerView.backgroundColor = .systemGray6
        containerView.layer.cornerRadius = 16

        // Status Dot
        statusDot.translatesAutoresizingMaskIntoConstraints = false
        statusDot.layer.cornerRadius = 6
        NSLayoutConstraint.activate([
            statusDot.widthAnchor.constraint(equalToConstant: 12),
            statusDot.heightAnchor.constraint(equalToConstant: 12)
        ])

        // Labels
        tickerLabel.font = .boldSystemFont(ofSize: 16)
        nameLabel.font = .systemFont(ofSize: 14)
        nameLabel.textColor = .secondaryLabel

        pnlAmountLabel.font = .boldSystemFont(ofSize: 16)
        pnlPercentageLabel.font = .systemFont(ofSize: 13)
        pnlPercentageLabel.layer.cornerRadius = 10
        pnlPercentageLabel.clipsToBounds = true
        pnlPercentageLabel.textAlignment = .center
        
        // Status Dot
        statusDot.translatesAutoresizingMaskIntoConstraints = false
        statusDot.layer.cornerRadius = 6
        statusDot.backgroundColor = .gray
        NSLayoutConstraint.activate([
            statusDot.widthAnchor.constraint(equalToConstant: 12),
            statusDot.heightAnchor.constraint(equalToConstant: 12)
        ])

        // Labels
        tickerLabel.font = .boldSystemFont(ofSize: 16)
        nameLabel.font = .systemFont(ofSize: 14)
        nameLabel.textColor = .secondaryLabel

        pnlAmountLabel.font = .boldSystemFont(ofSize: 16)
        pnlPercentageLabel.font = .systemFont(ofSize: 13)
        pnlPercentageLabel.layer.cornerRadius = 10
        pnlPercentageLabel.clipsToBounds = true
        pnlPercentageLabel.textAlignment = .center

        // Stack with status dot + ticker label (better alignment)
        let tickerWithDotStack = UIStackView(arrangedSubviews: [statusDot, tickerLabel])
        tickerWithDotStack.axis = .horizontal
        tickerWithDotStack.spacing = 6
        tickerWithDotStack.alignment = .center

        let titleStack = UIStackView(arrangedSubviews: [tickerWithDotStack, nameLabel])
        titleStack.axis = .vertical
        titleStack.spacing = 4

        // Right Stack (P&L)
        let rightStack = UIStackView(arrangedSubviews: [pnlAmountLabel, pnlPercentageLabel])
        rightStack.axis = .vertical
        rightStack.spacing = 4
        rightStack.alignment = .trailing

        // Main Stack
        let mainStack = UIStackView(arrangedSubviews: [titleStack, rightStack])
        mainStack.axis = .horizontal
        mainStack.alignment = .center
        mainStack.distribution = .equalSpacing
        mainStack.translatesAutoresizingMaskIntoConstraints = false

        containerView.addSubview(mainStack)
        NSLayoutConstraint.activate([
            mainStack.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            mainStack.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16),
            mainStack.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            mainStack.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16)
        ])
    }

    required init?(coder: NSCoder) { fatalError() }

    func configure(with item: DisplayItem) {
        tickerLabel.text = item.ticker
        nameLabel.text = item.name

        guard let pnlValue = Double(item.pnl),
              let pnlPercentageValue = Double(item.pnlPercentage) else {
            pnlAmountLabel.text = "$0.00"
            pnlPercentageLabel.text = "0.00%"
            return
        }

        let isPositive = pnlValue >= 0
        let pnlColor = isPositive ? UIColor.systemGreen : UIColor.systemRed
        let bgColor = isPositive ? UIColor.systemGreen.withAlphaComponent(0.1) : UIColor.systemRed.withAlphaComponent(0.1)

        statusDot.backgroundColor = isPositive ? .systemGreen : .systemRed
        pnlAmountLabel.textColor = pnlColor
        pnlAmountLabel.text = String(format: "%@%.2f", isPositive ? "+$" : "-$", abs(pnlValue))

        pnlPercentageLabel.text = String(format: "%@%.2f%%", isPositive ? "+" : "-", abs(pnlPercentageValue))
        pnlPercentageLabel.backgroundColor = bgColor
        pnlPercentageLabel.textColor = pnlColor
    }
}

struct DisplayItem {
    let ticker: String
    let name: String
    let pnl: String
    let pnlPercentage: String
    let headerSummary: String?

    init(position: Position) {
        self.ticker = position.instrument.ticker
        self.name = position.instrument.name
        self.pnl = String(format: "%.2f", position.pnl)
        self.pnlPercentage = String(format: "%.2f", position.pnlPercentage)
        self.headerSummary = nil
    }

    init(balance: Balance) {
        self.ticker = "Balance"
        self.name = "Net: $\(String(format: "%.2f", balance.netValue))"
        self.pnl = String(format: "%.2f", balance.pnl)
        self.pnlPercentage = String(format: "%.2f", balance.pnlPercentage)
        self.headerSummary = "Net Value: $\(balance.netValue) | PnL: $\(balance.pnl) | PnL %: \(balance.pnlPercentage)%"
    }

}

// PaddingLabel: UILabel subclass with padding for badge-like display
class PaddingLabel: UILabel {
    var insets = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)

    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: insets))
    }

    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + insets.left + insets.right,
                      height: size.height + insets.top + insets.bottom)
    }
}
