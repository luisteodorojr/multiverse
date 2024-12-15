//
//  CharacterDetailTableViewCell.swift
//  Multiverse
//
//  Created by Luis Teodoro on 13/12/24.
//

import UIKit
import SDWebImage

class CharacterDetailTableViewCell: UITableViewCell {
    
    private lazy var characterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 16
        return imageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var cardView: CardView = {
        let view = CardView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var infoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 8
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
        contentView.addSubview(characterImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(cardView)
        cardView.addSubview(infoStackView)
        
        NSLayoutConstraint.activate([
            characterImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: .defaultMargin),
            characterImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            characterImageView.widthAnchor.constraint(equalToConstant: 120),
            characterImageView.heightAnchor.constraint(equalToConstant: 120),
            
            nameLabel.topAnchor.constraint(equalTo: characterImageView.bottomAnchor, constant: .defaultMargin),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .defaultMargin),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.defaultMargin),
            
            cardView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: .defaultMargin),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .defaultMargin),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.defaultMargin),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -.defaultMargin),
            
            infoStackView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: .defaultMargin),
            infoStackView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: .defaultMargin),
            infoStackView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -.defaultMargin),
            infoStackView.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -.defaultMargin),
        ])
    }
    
    func configure(with character: Character) {
        characterImageView.sd_setImage(with: URL(string: character.image ?? ""), placeholderImage: UIImage(named: "placeholder"))
        nameLabel.text = character.name
        
        setupInfoStackView(with: [
            ("Specie", character.species ?? "Unknown"),
            ("Status", character.status ?? "Unknown"),
            ("Gender", character.gender ?? "Unknown"),
            ("Origin", character.origin?.name ?? "Unknown"),
            ("Location", character.location?.name ?? "Unknown")
        ])
    }
    
    private func setupInfoStackView(with info: [(String, String)]) {
        infoStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        info.forEach { (key, value) in
            let stack = createKeyValueStack(key: key, value: value)
            infoStackView.addArrangedSubview(stack)
        }
    }
    
    private func createKeyValueStack(key: String, value: String) -> UIStackView {
        let keyLabel = UILabel()
        keyLabel.translatesAutoresizingMaskIntoConstraints = false
        keyLabel.font = .systemFont(ofSize: 14, weight: .bold)
        keyLabel.textColor = .darkGray
        keyLabel.text = key
        
        let valueLabel = UILabel()
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        valueLabel.font = .systemFont(ofSize: 14)
        valueLabel.textColor = .black
        valueLabel.text = value
        valueLabel.textAlignment = .right
        
        let stackView = UIStackView(arrangedSubviews: [keyLabel, valueLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        
        return stackView
    }
}
extension CharacterDetailTableViewCell {
    func configureEpisodeCell(episodeNumber: String) {
        setupInfoStackView(with: [("Episode", "Episode \(episodeNumber)")])
        accessoryType = .disclosureIndicator
    }
}
