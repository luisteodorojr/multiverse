//
//  LoadingView.swift
//  Multiverse
//
//  Created by Luis Teodoro on 14/12/24.
//

import UIKit

class LoadingView: UIView {
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .white
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = UIColor.black.withAlphaComponent(0.5)
        addSubview(activityIndicator)
        addSubview(messageLabel)
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            messageLabel.topAnchor.constraint(equalTo: activityIndicator.bottomAnchor, constant: .defaultMargin),
            messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .defaultMargin),
            messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.defaultMargin)
        ])
        
        activityIndicator.startAnimating()
    }
    
    func configure(message: String? = nil) {
        messageLabel.text = message
        messageLabel.isHidden = (message == nil)
    }
}
