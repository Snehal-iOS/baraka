//
//  PortfolioViewController.swift
//  Baraka
//
//  Created by Snehal on 23/06/2025.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class PortfolioViewController: UIViewController {
    
    private let collectionView: UICollectionView
    private let viewModel = PortfolioViewModel()
    private let disposeBag = DisposeBag()


    private var dataSource: RxCollectionViewSectionedReloadDataSource<SectionModel<String, DisplayItem>>!

    init() {
        let layout = UICollectionViewCompositionalLayout { section, _ in
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(80))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 0, bottom: 4, trailing: 0)

            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(80))
            let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = 12
            section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16)

            return section
        }
        
        self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
        setupBinding()
        viewModel.fetchData()
        viewModel.startSimulatingPrices()
    }

    
    private let greetingStack = UIStackView()
    private let userImageView = UIImageView()
    private let greetingLabel = UILabel()
    private let subGreetingLabel = UILabel()
    private let yourHoldingsLabel = UILabel()

    private let balanceHeaderView = BalanceHeaderView()

    private func setupUI() {
        
        // User Image
        userImageView.image = UIImage(systemName: "person.circle.fill")
        userImageView.tintColor = .label
        userImageView.contentMode = .scaleAspectFill
        userImageView.clipsToBounds = true
        userImageView.layer.cornerRadius = 24
        userImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            userImageView.widthAnchor.constraint(equalToConstant: 48),
            userImageView.heightAnchor.constraint(equalToConstant: 48)
        ])

        // Greeting Labels
        greetingLabel.text = "Hi Snehal,"
        greetingLabel.font = UIFont.boldSystemFont(ofSize: 18)

        subGreetingLabel.text = "Welcome back!"
        subGreetingLabel.font = UIFont.systemFont(ofSize: 14)
        subGreetingLabel.textColor = .gray

        let textStack = UIStackView(arrangedSubviews: [greetingLabel, subGreetingLabel])
        textStack.axis = .vertical
        textStack.spacing = 4

        // Theme toggle button
        let themeToggleButton = UIButton(type: .system)
        themeToggleButton.setImage(UIImage(systemName: "moon.fill"), for: .normal)
        themeToggleButton.tintColor = .label
        themeToggleButton.addTarget(self, action: #selector(toggleTheme), for: .touchUpInside)
        themeToggleButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            themeToggleButton.widthAnchor.constraint(equalToConstant: 30),
            themeToggleButton.heightAnchor.constraint(equalToConstant: 30),
        ])

        // Create main greeting stack
        let leadingStack = UIStackView(arrangedSubviews: [userImageView, textStack])
        leadingStack.axis = .horizontal
        leadingStack.alignment = .center
        leadingStack.spacing = 12

        let greetingStack = UIStackView(arrangedSubviews: [leadingStack, themeToggleButton])
        greetingStack.axis = .horizontal
        greetingStack.alignment = .center
        greetingStack.distribution = .fillProportionally
        greetingStack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(greetingStack)


//         Balance Header
        balanceHeaderView.translatesAutoresizingMaskIntoConstraints = false
        balanceHeaderView.backgroundColor = .systemGray6
        balanceHeaderView.layer.cornerRadius = 16
        view.addSubview(balanceHeaderView)
        
        
        yourHoldingsLabel.text = "Your Holdings"
        yourHoldingsLabel.translatesAutoresizingMaskIntoConstraints = false
        yourHoldingsLabel.font = UIFont.boldSystemFont(ofSize: 18)
        view.addSubview(yourHoldingsLabel)

        // Collection View
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .systemBackground
        collectionView.register(PositionCell.self, forCellWithReuseIdentifier: "PositionCell")
        view.addSubview(collectionView)


        // Layout
        NSLayoutConstraint.activate([
            greetingStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            greetingStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            greetingStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            
            balanceHeaderView.topAnchor.constraint(equalTo: greetingStack.bottomAnchor, constant: 16),
            balanceHeaderView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            balanceHeaderView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            balanceHeaderView.heightAnchor.constraint(equalToConstant: 180),


            yourHoldingsLabel.topAnchor.constraint(equalTo: balanceHeaderView.bottomAnchor, constant: 16),
            yourHoldingsLabel.bottomAnchor.constraint(equalTo: collectionView.topAnchor),
            yourHoldingsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18),
            yourHoldingsLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 18),
            
            collectionView.topAnchor.constraint(equalTo: yourHoldingsLabel.bottomAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    @objc func toggleTheme() {
    let isDark = overrideUserInterfaceStyle == .dark
    overrideUserInterfaceStyle = isDark ? .light : .dark

        if let toggleButton = self.greetingStack.arrangedSubviews.last as? UIButton {
            let newIcon = isDark ? "moon.fill" : "sun.max.fill"
            toggleButton.setImage(UIImage(systemName: newIcon), for: .normal)
        }
}

    private func setupBinding() {
        dataSource = RxCollectionViewSectionedReloadDataSource<SectionModel<String, DisplayItem>>(configureCell: { _, cv, indexPath, item in
            let cell = cv.dequeueReusableCell(withReuseIdentifier: "PositionCell", for: indexPath) as! PositionCell
            cell.configure(with: item)
            return cell
        })
        
        viewModel.portfolio
            .compactMap { $0 }
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] portfolio in
                self?.balanceHeaderView.configure(with: portfolio.balance)

                let positionItems = portfolio.positions.map { DisplayItem(position: $0) }
                let section = [SectionModel(model: "Positions", items: positionItems)]
                self?.collectionView.dataSource = nil // clear old binding
                Observable.just(section)
                    .bind(to: self!.collectionView.rx.items(dataSource: self!.dataSource))
                    .disposed(by: self!.disposeBag)
            })
            .disposed(by: disposeBag)

    }
}
