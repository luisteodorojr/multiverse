//
//  LocationDetailViewController.swift
//  Multiverse
//
//  Created by Luis Teodoro on 13/12/24.
//

import UIKit

final class LocationDetailViewController: BaseViewController {
    
    private let viewModel: LocationDetailViewModel
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(EpisodeDetailTableViewCell.self, forCellReuseIdentifier: "DetailCell")
        tableView.register(CharacterCardTableViewCell.self, forCellReuseIdentifier: "ResidentCell")
        tableView.separatorStyle = .none
        return tableView
    }()
    
    init(viewModel: LocationDetailViewModel) {
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
        viewModel.fetchLocationDetails()
    }
    
    private func setupUI() {
        title = "Location Details"
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

extension LocationDetailViewController: LocationDetailViewModelDelegate {
    func didFetchLocationDetails() {
        DispatchQueue.main.async {
            self.hideError()
            self.tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
        }
    }
    
    func didFailToFetchLocationDetails(with error: Error) {
        DispatchQueue.main.async {
            self.showError(message: error.localizedDescription) { [weak self] in
                self?.viewModel.fetchLocationDetails()
            }
        }
    }
    
    func didFetchResidents() {
        DispatchQueue.main.async {
            self.hideError()
            self.hideLoading()
            self.tableView.reloadSections(IndexSet(integer: 1), with: .automatic)
        }
    }
    
    func didFailToFetchResidents(with error: Error) {
        DispatchQueue.main.async {
            self.hideLoading()
            self.showError(message: error.localizedDescription) { [weak self] in
                self?.viewModel.fetchResidents()
            }
        }
    }
}

extension LocationDetailViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 3 : viewModel.residents.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 1:
            return "Residents"
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "DetailCell", for: indexPath) as? EpisodeDetailTableViewCell else { return UITableViewCell() }
            let title = indexPath.row == 0 ? "Name" : indexPath.row == 1 ? "Type" : "Dimension"
            let value = indexPath.row == 0 ? viewModel.locationDetail?.name :
                        indexPath.row == 1 ? viewModel.locationDetail?.type : viewModel.locationDetail?.dimension
            cell.configure(title: title, value: value ?? "Unknown")
            return cell
        } else {
            let resident = viewModel.residents[indexPath.row]
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ResidentCell", for: indexPath) as? CharacterCardTableViewCell else { return UITableViewCell() }
            cell.configure(name: resident.name ?? "Unknown")
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            let resident = viewModel.residents[indexPath.row]
            viewModel.selectResident(withID: resident.id ?? 0)
        }
    }
}
