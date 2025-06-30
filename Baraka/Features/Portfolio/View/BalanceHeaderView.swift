//
//  BalanceHeaderView.swift
//  Baraka
//
//  Created by Snehal on 24/06/2025.
//
import UIKit

class BalanceHeaderView: UIView {

    private let containerView = UIView()
    private let titleLabel = UILabel()
    private let netValueLabel = UILabel()
    private let pnlAmountLabel = UILabel()
    private let pnlPercentageLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    private func setupUI() {
        backgroundColor = .clear
        addSubview(containerView)

        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = .clear

        titleLabel.text = "NET PORTFOLIO VALUE"
        titleLabel.font = .systemFont(ofSize: 12, weight: .semibold)
        titleLabel.textAlignment = .center
        titleLabel.textColor = .gray

        netValueLabel.font = .systemFont(ofSize: 32, weight: .bold)
        netValueLabel.textAlignment = .center
        netValueLabel.textColor = .label

        pnlAmountLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        pnlPercentageLabel.font = .systemFont(ofSize: 16, weight: .semibold)

        let bottomStack = UIStackView(arrangedSubviews: [pnlAmountLabel, pnlPercentageLabel])
        bottomStack.axis = .horizontal
        bottomStack.distribution = .fillEqually
        bottomStack.spacing = 16

        let stack = UIStackView(arrangedSubviews: [titleLabel, netValueLabel, bottomStack])
        stack.axis = .vertical
        stack.spacing = 12
        stack.translatesAutoresizingMaskIntoConstraints = false

        containerView.addSubview(stack)

        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),

            stack.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
            stack.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            stack.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20)
        ])
    }

    func configure(with balance: Balance) {
        netValueLabel.text = balance.netValue.formatted(.currency(code: "USD"))
                pnlAmountLabel.numberOfLines = 2
                pnlAmountLabel.textAlignment = .center
                pnlPercentageLabel.numberOfLines = 2
                pnlPercentageLabel.textAlignment = .center

        let titleColor = UIColor.gray
        let valueColor = balance.pnl >= 0 ? UIColor.systemGreen : UIColor.systemRed

        let pnlTitle = NSAttributedString(string: "In Dollars\n", attributes: [
            .foregroundColor: titleColor,
            .font: UIFont.systemFont(ofSize: 13)
        ])
        let pnlValue = NSAttributedString(string: balance.pnl.formatted(.currency(code: "USD")), attributes: [
            .foregroundColor: valueColor,
            .font: UIFont.systemFont(ofSize: 18, weight: .semibold)
        ])
        let pnlAttrText = NSMutableAttributedString()
        pnlAttrText.append(pnlTitle)
        pnlAttrText.append(pnlValue)
        pnlAmountLabel.attributedText = pnlAttrText

        let returnTitle = NSAttributedString(string: "In Percentage\n", attributes: [
            .foregroundColor: titleColor,
            .font: UIFont.systemFont(ofSize: 13)
        ])
        let returnValue = NSAttributedString(string: String(format: "%.2f%%", balance.pnlPercentage), attributes: [
            .foregroundColor: valueColor,
            .font: UIFont.systemFont(ofSize: 18, weight: .semibold)
        ])
        let returnAttrText = NSMutableAttributedString()
        returnAttrText.append(returnTitle)
        returnAttrText.append(returnValue)
        pnlPercentageLabel.attributedText = returnAttrText
    }
}


