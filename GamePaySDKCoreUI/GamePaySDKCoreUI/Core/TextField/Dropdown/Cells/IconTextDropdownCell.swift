//
//  IconTextDropdownCell.swift
//  GamePaySDKCoreUI
//
//  Created by Luke Nguyen on 28/7/25.
//

import UIKit

class IconTextDropdownCell: HorizontalDropdownCell {
    private let iconView = UIImageView()
    private let titleLabel = UILabel()
    private let selectedIconView = UIImageView()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        iconView.image = nil
        titleLabel.text = nil
        selectedIconView.isHidden = true
    }

    override func setupView() {
        iconView.widthAnchor.constraint(equalToConstant: 32).isActive = true
        iconView.heightAnchor.constraint(equalToConstant: 32).isActive = true

        iconView.contentMode = .scaleAspectFit
        titleLabel.numberOfLines = 0
        titleLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        selectedIconView.image = GPAssets.icCheckmark.image
        selectedIconView.translatesAutoresizingMaskIntoConstraints = false
        selectedIconView.widthAnchor.constraint(equalToConstant: 24).isActive = true
        selectedIconView.heightAnchor.constraint(equalToConstant: 24).isActive = true
        selectedIconView.isHidden = true

        stackView.addArrangedSubview(iconView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(selectedIconView)
    }

    override func configureCell(with option: DropdownOption, theme: GPTheme) {
        super.configureCell(with: option, theme: theme)
        
        titleLabel.text = option.name
        titleLabel.font = theme.typography.body1

        iconView.image = nil
        if let url = option.logoUrl {
            iconView.loadImage(from: url)
        }
        
        selectedIconView.isHidden = !isSelectedCell

        divider.backgroundColor = theme.colors.borderSubtle
    }
}
