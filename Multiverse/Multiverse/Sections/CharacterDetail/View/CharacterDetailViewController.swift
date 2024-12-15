//
//  CharacterDetailViewController.swift
//  Multiverse
//
//  Created by Luis Teodoro on 13/12/24.
//

import UIKit

final class CharacterDetailViewController: BaseViewController {
    
    private let viewModel: CharacterDetailViewModel
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CharacterDetailTableViewCell.self, forCellReuseIdentifier: "CharacterImageCell")
        tableView.register(EpisodeTableViewCell.self, forCellReuseIdentifier: "EpisodeCell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44
        tableView.separatorStyle = .none
        return tableView
    }()
    
    init(viewModel: CharacterDetailViewModel) {
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
        viewModel.fetchCharacterDetails()
    }
    
    private func setupUI() {
        title = "Detalhes"
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

extension CharacterDetailViewController: CharacterDetailViewModelDelegate {
    func didFetchCharacterDetails() {
        DispatchQueue.main.async {
            self.hideError()
            self.hideLoading()
            self.tableView.reloadData()
        }
    }
    
    func didFailToFetchCharacterDetails(with error: Error) {
        DispatchQueue.main.async {
            self.hideLoading()
            self.showError(message: error.localizedDescription) { [weak self] in
                self?.viewModel.fetchCharacterDetails()
            }
        }
    }
}

extension CharacterDetailViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let character = viewModel.character else { return 0 }
        
        switch section {
        case 0:
            return 1
        case 1:
            return character.episode?.count ?? 0
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return UITableView.automaticDimension
        case 1:
            return 60
        default:
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 1:
            return "Episode"
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let character = viewModel.character else { return UITableViewCell() }
        
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "CharacterImageCell", for: indexPath) as? CharacterDetailTableViewCell else {
                return UITableViewCell()
            }
            cell.configure(with: character)
            return cell
            
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "EpisodeCell", for: indexPath) as? EpisodeTableViewCell else {
                return UITableViewCell()
            }
            
            if let episodeURL = character.episode?[indexPath.row] {
                let episodeNumber = extractEpisodeNumber(from: episodeURL)
                cell.configure(with: episodeNumber)
            }
            return cell
            
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard indexPath.section == 1 else { return }
        viewModel.getEpisodeID(at: indexPath.row)
    }

    private func extractEpisodeNumber(from url: String) -> String {
        return url.components(separatedBy: "/").last ?? "Unknown"
    }
}
