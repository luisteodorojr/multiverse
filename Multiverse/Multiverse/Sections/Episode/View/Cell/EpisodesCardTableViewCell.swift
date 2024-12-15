//
//  EpisodeTableViewCell.swift
//  Multiverse
//
//  Created by Luis Teodoro on 13/12/24.
//

import UIKit

class EpisodesCardTableViewCell: UITableViewCell {
    
    private lazy var cardView: CardView = {
        let view = CardView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .boldSystemFont(ofSize: 16)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var airDateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14)
        label.textColor = .gray
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var chevronImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "chevron.right")
        imageView.tintColor = .gray
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(cardView)
        cardView.addSubview(titleLabel)
        cardView.addSubview(airDateLabel)
        cardView.addSubview(chevronImageView)
        
        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: .smallMargin),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .defaultMargin),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.defaultMargin),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -.smallMargin),
            
            chevronImageView.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            chevronImageView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -.defaultMargin),
            chevronImageView.widthAnchor.constraint(equalToConstant: .defaultIconSize),
            chevronImageView.heightAnchor.constraint(equalToConstant: .defaultIconSize),
            
            titleLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: .defaultMargin),
            titleLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: .defaultMargin),
            titleLabel.trailingAnchor.constraint(equalTo: chevronImageView.leadingAnchor, constant: -.smallMargin),
            
            airDateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: .smallMargin),
            airDateLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: .defaultMargin),
            airDateLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -.defaultMargin),
            airDateLabel.bottomAnchor.constraint(lessThanOrEqualTo: cardView.bottomAnchor, constant: -.defaultMargin)
        ])
    }
    
    func configure(with episode: Episode) {
        titleLabel.text = episode.name
        airDateLabel.text = "Air Date: \(episode.airDate ?? "")"
    }
}
