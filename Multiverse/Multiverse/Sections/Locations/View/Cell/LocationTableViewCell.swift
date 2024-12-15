//
//  LocationTableViewCell.swift
//  Multiverse
//
//  Created by Luis Teodoro on 13/12/24.
//

import UIKit

class LocationTableViewCell: UITableViewCell {
    
    private lazy var cardView: CardView = {
        let view = CardView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .boldSystemFont(ofSize: 16)
        return label
    }()
    
    private lazy var typeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14)
        label.textColor = .gray
        return label
    }()
    
    private lazy var dimensionLabel: UILabel = {
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
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        let textStackView = UIStackView(arrangedSubviews: [nameLabel, typeLabel, dimensionLabel])
        textStackView.axis = .vertical
        textStackView.spacing = 4
        textStackView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(cardView)
        cardView.addSubview(textStackView)
        cardView.addSubview(actionImageView)
        
        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: .smallMargin),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .smallMargin),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.smallMargin),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -.smallMargin),
            
            textStackView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: .defaultMargin),
            textStackView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: .defaultMargin),
            textStackView.trailingAnchor.constraint(lessThanOrEqualTo: actionImageView.leadingAnchor, constant: -.defaultMargin),
            textStackView.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -.defaultMargin),
            
            actionImageView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -.defaultMargin),
            actionImageView.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            actionImageView.widthAnchor.constraint(equalToConstant: .defaultIconSize),
            actionImageView.heightAnchor.constraint(equalToConstant: .defaultIconSize)
        ])
    }
    
    func configure(with location: LocationDetail) {
        nameLabel.text = location.name
        typeLabel.text = "Type: \(location.type ?? "")"
        dimensionLabel.text = "Dimension: \(location.dimension ?? "")"
    }
}
