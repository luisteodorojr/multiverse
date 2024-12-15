//
//  EpisodeTableViewCell.swift
//  Multiverse
//
//  Created by Luis Teodoro on 13/12/24.
//

import UIKit

class EpisodeTableViewCell: UITableViewCell {
    
    private lazy var cardView: CardView = {
        let view = CardView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = .black
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
        cardView.addSubview(chevronImageView)
        
        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: .smallMargin),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .defaultMargin),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.defaultMargin),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -.smallMargin),
            
            titleLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: .defaultMargin),
            titleLabel.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            
            chevronImageView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -.defaultMargin),
            chevronImageView.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            chevronImageView.widthAnchor.constraint(equalToConstant: .defaultMargin),
            chevronImageView.heightAnchor.constraint(equalToConstant: .defaultMargin)
        ])
    }
    
    func configure(with episodeNumber: String) {
        titleLabel.text = "Episode \(episodeNumber)"
    }
}
