//
//  GPIconTextDropdownCell.swift
//  GamePaySDKCoreUI
//
//  Created by Luke Nguyen on 28/7/25.
//

import UIKit

public class GPIconTextDropdownCell: GPHorizontalDropdownCell {
    private lazy var iconView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.widthAnchor.constraint(equalToConstant: 32).isActive = true
        view.heightAnchor.constraint(equalToConstant: 32).isActive = true
        return view
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return label
    }()
    private let selectedIconView: UIImageView = {
        let view = UIImageView()
        view.image = GPCoreUIAssets.icCheckmark.image
        view.translatesAutoresizingMaskIntoConstraints = false
        view.widthAnchor.constraint(equalToConstant: 24).isActive = true
        view.heightAnchor.constraint(equalToConstant: 24).isActive = true
        view.isHidden = true
        return view
    }()
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        iconView.image = nil
        titleLabel.text = nil
        selectedIconView.isHidden = true
    }
    
    override func getSubviews() -> [UIView] {
        return [iconView, titleLabel, selectedIconView]
    }

    public override func configureCell(with option: GPDropdownOption, isSelectedCell: Bool, theme: GPTheme) {
        super.configureCell(with: option, isSelectedCell: isSelectedCell, theme: theme)
        
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
