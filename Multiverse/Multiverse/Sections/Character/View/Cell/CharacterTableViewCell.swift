//
//  CharacterTableViewCell.swift
//  Multiverse
//
//  Created by Luis Teodoro on 12/12/24.
//

import UIKit
import SDWebImage

class CharacterTableViewCell: UITableViewCell {
    
    private lazy var cardView: CardView = {
        let view = CardView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var characterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        return imageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .boldSystemFont(ofSize: 16)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var speciesLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14)
        label.textColor = .gray
        return label
    }()
    
    private lazy var actionImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "chevron.right")
        imageView.tintColor = .gray
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var textStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [nameLabel, speciesLabel])
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [characterImageView, textStackView, actionImageView])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
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
        cardView.addSubview(mainStackView)
        
        NSLayoutConstraint.activate([
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .smallMargin),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.smallMargin),
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: .smallMargin),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -.smallMargin),
            
            mainStackView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: .defaultMargin),
            mainStackView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -.defaultMargin),
            mainStackView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: .defaultMargin),
            mainStackView.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -.defaultMargin),
            
            characterImageView.widthAnchor.constraint(equalToConstant: 80),
            characterImageView.heightAnchor.constraint(equalToConstant: 80),
            
            actionImageView.widthAnchor.constraint(equalToConstant: .defaultIconSize),
            actionImageView.heightAnchor.constraint(equalToConstant: .defaultIconSize)
        ])
    }
    
    func configure(with character: Character) {
        nameLabel.text = character.name
        speciesLabel.text = character.species
        characterImageView.sd_setImage(with: URL(string: character.image ?? ""), placeholderImage: UIImage(named: "placeholder"))
    }
}
