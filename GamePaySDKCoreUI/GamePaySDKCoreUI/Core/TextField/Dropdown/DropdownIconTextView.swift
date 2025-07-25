//
//  DropdownIconTextView.swift
//  GamePaySDKCoreUI
//
//  Created by Luke Nguyen on 25/7/25.
//

import UIKit

class DropdownIconTextView: DropdownOptionView {
    private let iconView = UIImageView()
    private let titleLabel = UILabel()
    private let selectedIconView = UIImageView()

    override func setupView() {
        iconView.translatesAutoresizingMaskIntoConstraints = false
        iconView.contentMode = .scaleAspectFit
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.numberOfLines = 1
        titleLabel.font = theme.typography.body1
        selectedIconView.translatesAutoresizingMaskIntoConstraints = false
        selectedIconView.image = GPAssets.icCheckmark.image
        
        NSLayoutConstraint.activate([
            iconView.widthAnchor.constraint(equalToConstant: 32),
            iconView.heightAnchor.constraint(equalToConstant: 32),
            selectedIconView.widthAnchor.constraint(equalToConstant: 24),
            selectedIconView.heightAnchor.constraint(equalToConstant: 24)
        ])

        configureSubviews([iconView, titleLabel, selectedIconView])
    }

    func configure(with option: DropdownOption, delegate: DropdownOptionViewDelegate, isSelected: Bool) {
        self.option = option
        self.delegate = delegate
        titleLabel.text = option.name
        titleLabel.font = theme.typography.body1
        iconView.image = nil
        if let logoUrl = option.logoUrl {
            iconView.loadImage(from: logoUrl)
        }
        selectedIconView.isHidden = !isSelected
    }
}
