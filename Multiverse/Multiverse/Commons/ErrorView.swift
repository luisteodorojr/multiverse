//
//  ErrorView.swift
//  Multiverse
//
//  Created by Luis Teodoro on 14/12/24.
//

import UIKit

class ErrorView: UIView {
    private let cardView: CardView = {
        let view = CardView()
        return view
    }()
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "exclamationmark.circle.fill")
        imageView.tintColor = .systemRed
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Ocorreu um erro"
        label.font = .boldSystemFont(ofSize: 18)
        label.textColor = .black
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .darkGray
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let retryButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Tentar novamente", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 16)
        button.setTitleColor(.systemBlue, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var retryAction: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = UIColor.white
        
        addSubview(cardView)
        cardView.addSubview(stackView)
        
        retryButton.addTarget(self, action: #selector(retryButtonTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            cardView.centerXAnchor.constraint(equalTo: centerXAnchor),
            cardView.centerYAnchor.constraint(equalTo: centerYAnchor),
            cardView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.8),
            cardView.heightAnchor.constraint(greaterThanOrEqualToConstant: 200),
            
            stackView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: .defaultMargin),
            stackView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: .defaultMargin),
            stackView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -.defaultMargin),
            stackView.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -.defaultMargin)
        ])
    }
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [iconImageView, titleLabel, messageLabel, retryButton])
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        iconImageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        iconImageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        return stack
    }()
    
    @objc private func retryButtonTapped() {
        retryAction?()
    }
    
    func configure(message: String, retryAction: (() -> Void)? = nil) {
        messageLabel.text = message
        self.retryAction = retryAction
    }
}
