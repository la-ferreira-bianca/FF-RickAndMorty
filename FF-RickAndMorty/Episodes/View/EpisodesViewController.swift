//
//  EpisodesViewController.swift
//  FF-RickAndMorty
//
//  Created by Bianca Ferreira on 22/12/23.
//

import UIKit

class EpisodesViewController: UIViewController {
    //MARK: - Properties
    var viewModel: EpisodesViewModel?
    
    //MARK: - Private Properties
    private (set) var episodes: [Episode] = []
    
    //MARK: - Views
    lazy var tableView: UITableView = {
        let table = UITableView()
        table.dataSource = self
        table.delegate = self
        table.estimatedRowHeight = 50
        table.rowHeight = 50
        table.separatorStyle = .none
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        loadTableView()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
            self.tableView.reloadData()
            self.tableView.stopSkeletonAnimation()
            self.view.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(0.25))
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.isSkeletonable = true
        self.tableView.showAnimatedSkeleton(usingColor: .amethyst,
                                            transition: .crossDissolve(0.25))
    }
    
    //MARK: - Private Functions
    private func loadTableView(completion: (() -> Void)? = nil) {
        viewModel?.getEpisodes { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                self.episodes = response.results
                completion?()
                
            case .failure(let failure):
                print("error \(failure)")
                completion?()
            }
        }
    }
    
    private func setupViews() {
        view.addSubview(tableView)
        view.backgroundColor = .blue
        navigationItem.title = "Episodes"
        
        setupCells()
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupCells() {
        self.tableView.register(EpisodesCell.self, forCellReuseIdentifier: "cell")
    }
}

