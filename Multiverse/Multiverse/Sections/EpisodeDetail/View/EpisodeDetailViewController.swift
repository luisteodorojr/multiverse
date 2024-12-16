//
//  EpisodeDetailViewController.swift
//  Multiverse
//
//  Created by Luis Teodoro on 13/12/24.
//

import UIKit

final class EpisodeDetailViewController: BaseViewController {
    
    private let viewModel: EpisodeDetailViewModel
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(EpisodeDetailTableViewCell.self, forCellReuseIdentifier: "EpisodeDetailCell")
        tableView.register(CharacterCardTableViewCell.self, forCellReuseIdentifier: "CharacterCell")
        tableView.separatorStyle = .none
        return tableView
    }()
    
    init(viewModel: EpisodeDetailViewModel) {
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
        viewModel.fetchEpisodeDetails()
    }
    
    private func setupUI() {
        title = "Episode Details"
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

extension EpisodeDetailViewController: EpisodeDetailViewModelDelegate {
    func didFetchEpisodeDetails() {
        DispatchQueue.main.async {
            self.hideError()
            self.tableView.reloadData()
        }
    }
    
    func didFailToFetchEpisodeDetails(with error: Error) {
        DispatchQueue.main.async {
            self.hideLoading()
            self.showError(message: error.localizedDescription) { [weak self] in
                self?.viewModel.fetchEpisodeDetails()
            }
        }
    }
    
    func didFetchEpisodeCharacters() {
        DispatchQueue.main.async {
            self.hideError()
            self.hideLoading()
            self.tableView.reloadSections(IndexSet(integer: 1), with: .automatic)
        }
    }
    
    func didFailToFetchEpisodeCharacters(with error: Error) {
        DispatchQueue.main.async {
            self.hideLoading()
            self.showError(message: error.localizedDescription) { [weak self] in
                self?.viewModel.fetchEpisodeCharacters()
            }
        }
    }
}

extension EpisodeDetailViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 2
        case 1:
            return viewModel.characters.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Episode Details"
        case 1:
            return "Character"
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "EpisodeDetailCell", for: indexPath) as? EpisodeDetailTableViewCell else {
                return UITableViewCell()
            }
            if indexPath.row == 0 {
                cell.configure(title: "Name", value: viewModel.episodeDetail?.name ?? "Unknown")
            } else {
                cell.configure(title: "Air Date", value: viewModel.episodeDetail?.airDate ?? "Unknown")
            }
            return cell
            
        case 1: 
            let character = viewModel.characters[indexPath.row]
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "CharacterCell", for: indexPath) as? CharacterCardTableViewCell else {
                return UITableViewCell()
            }
            cell.configure(name: character.name ?? "")
            return cell
            
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 1 {
            let character = viewModel.characters[indexPath.row]
            navigateToCharacterDetails(character: character)
        }
    }
    
    private func navigateToCharacterDetails(character: Character) {
        viewModel.selectCharacter(withId: character.id ?? 0)
    }
}
