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
    //TODO: remove the hardcode number get from api
    private var numberOfPages: Int = 7
    private var currentPage: Int = 1
    
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
    
    lazy var nextPageButton: UIButton = {
        let button = UIButton()
        button.setTitle("Proximo", for: .normal)
        button.backgroundColor = .gray
        button.addTarget(self, action: #selector(nextTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var beforeButton: UIButton = {
        let button = UIButton()
        button.setTitle("Anterior", for: .normal)
        button.backgroundColor = .gray
        button.addTarget(self, action: #selector(beforeTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        loadTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.isSkeletonable = true
        reloadTableView()
    }
    
    //MARK: - objc Functions
    @objc func nextTapped(_ sender: Any) {
        if currentPage < numberOfPages {
            currentPage += 1
            loadTableView(page: currentPage)
        }
    }
    
    @objc func beforeTapped(_ sender: Any) {
        if currentPage > 1 {
            currentPage -= 1
            loadTableView(page: currentPage)
        }
    }
    
    //MARK: - Private Functions
    private func loadTableView(page: Int = 1, success: ((Bool) -> Void)? = nil) {
        Task {
            viewModel?.getEpisodes(pageNumber: page, completion: { episodes in
                self.episodes = episodes
                DispatchQueue.main.async {
                    self.reloadTableView()
                }
            })
        }
    }
    
    private func setupViews() {
        view.addSubview(tableView)
        view.addSubview(nextPageButton)
        view.addSubview(beforeButton)
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
            tableView.bottomAnchor.constraint(equalTo: nextPageButton.topAnchor, constant: -10),
            
            nextPageButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            nextPageButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            nextPageButton.widthAnchor.constraint(equalToConstant: 150),
            nextPageButton.heightAnchor.constraint(equalToConstant: 50),
            
            beforeButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            beforeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            beforeButton.widthAnchor.constraint(equalToConstant: 150),
            beforeButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func setupCells() {
        self.tableView.register(EpisodesCell.self, forCellReuseIdentifier: "cell")
    }
    
    private func reloadTableView() {
        self.tableView.showAnimatedSkeleton(usingColor: .amethyst,
                                            transition: .crossDissolve(0.25))
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
            self.tableView.reloadData()
            self.tableView.stopSkeletonAnimation()
            self.view.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(0.25))
        })
    }
}

