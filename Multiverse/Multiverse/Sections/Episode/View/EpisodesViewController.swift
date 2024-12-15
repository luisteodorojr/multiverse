//
//  EpisodesViewController.swift
//  Multiverse
//
//  Created by Luis Teodoro on 13/12/24.
//

import UIKit

final class EpisodesViewController: BaseViewController {
    private let viewModel: EpisodesViewModel
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(EpisodesCardTableViewCell.self, forCellReuseIdentifier: "EpisodeCell")
        return tableView
    }()
    
    init(viewModel: EpisodesViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.viewModel.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackButtonAppearance()
        setupUI()
        showLoading()
        viewModel.fetchEpisodes()
    }
    
    private func setupUI() {
        title = "Episodes"
        view.backgroundColor = .white
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension EpisodesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.episodes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "EpisodeCell", for: indexPath) as? EpisodesCardTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(with: viewModel.episodes[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel.selectEpisode(at: indexPath.row)
    }
}

extension EpisodesViewController: EpisodesViewModelDelegate {
    func didUpdateEpisodes(_ episodes: [Episode]) {
        DispatchQueue.main.async {
            self.hideError()
            self.hideLoading()
            self.tableView.reloadData()
        }
    }
    
    func didFailWithError(_ error: Error) {
        DispatchQueue.main.async {
            self.hideLoading()
            self.showError(message: error.localizedDescription) { [weak self] in
                self?.viewModel.fetchEpisodes()
            }
        }
    }
}
