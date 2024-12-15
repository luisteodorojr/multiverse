//
//  CharacterCardTableViewCell.swift
//  Multiverse
//
//  Created by Luis Teodoro on 13/12/24.
//

import UIKit

class CharacterCardTableViewCell: UITableViewCell {
    
    private lazy var cardView: CardView = {
        let view = CardView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .boldSystemFont(ofSize: 16)
        label.numberOfLines = 0
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
        cardView.addSubview(nameLabel)
        cardView.addSubview(chevronImageView)
        
        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: .smallMargin),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .defaultMargin),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.defaultMargin),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -.smallMargin),
 
            nameLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: .defaultMargin),
            nameLabel.trailingAnchor.constraint(equalTo: chevronImageView.leadingAnchor, constant: -.smallMargin),
            nameLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: .defaultMargin),
            nameLabel.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -.defaultMargin),
       
            chevronImageView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -.defaultMargin),
            chevronImageView.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            chevronImageView.widthAnchor.constraint(equalToConstant: .defaultIconSize),
            chevronImageView.heightAnchor.constraint(equalToConstant: .defaultIconSize)
        ])
    }
    
    func configure(name: String) {
        nameLabel.text = name
    }
}
