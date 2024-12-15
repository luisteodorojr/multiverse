//
//  CardView.swift
//  Multiverse
//
//  Created by Luis Teodoro on 12/12/24.
//

import UIKit

class CardView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        backgroundColor = .white
        layer.cornerRadius = 12
        layer.borderWidth = 1
        layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        translatesAutoresizingMaskIntoConstraints = false
    }
}
