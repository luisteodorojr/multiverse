//
//  EpisodeDetailTableViewCell.swift
//  Multiverse
//
//  Created by Luis Teodoro on 13/12/24.
//

import UIKit

class EpisodeDetailTableViewCell: UITableViewCell {
    
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
    
    private lazy var valueLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14)
        label.textColor = .gray
        label.numberOfLines = 0
        return label
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
        cardView.addSubview(valueLabel)
        
        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: .smallMargin),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .defaultMargin),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.defaultMargin),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -.smallMargin),
            
            titleLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: .defaultMargin),
            titleLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: .defaultMargin),
            titleLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -.defaultMargin),
            
            valueLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: .smallMargin),
            valueLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: .defaultMargin),
            valueLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -.defaultMargin),
            valueLabel.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -.defaultMargin)
        ])
    }
    
    func configure(title: String, value: String) {
        titleLabel.text = title
        valueLabel.text = value
    }
}
