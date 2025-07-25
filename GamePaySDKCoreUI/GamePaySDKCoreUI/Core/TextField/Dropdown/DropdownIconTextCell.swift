//
//  DropdownIconTextCell.swift
//  GamePaySDKCoreUI
//
//  Created by Luke Nguyen on 25/7/25.
//

import UIKit

class DropdownIconTextCell: DropdownOptionCell {
    private let iconView = UIImageView()
    private let titleLabel = UILabel()
    private let selectedIconView = UIImageView()

    override func setupView() {
        iconView.translatesAutoresizingMaskIntoConstraints = false
        iconView.contentMode = .scaleAspectFit
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
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

    func configure(with option: DropdownOption, theme: GPTheme, isSelected: Bool) {
        titleLabel.text = option.name
        titleLabel.font = theme.typography.body1
        iconView.image = nil
        if let logoUrl = option.logoUrl {
            iconView.loadImage(from: logoUrl)
        }
        selectedIconView.isHidden = !isSelected
    }
}
