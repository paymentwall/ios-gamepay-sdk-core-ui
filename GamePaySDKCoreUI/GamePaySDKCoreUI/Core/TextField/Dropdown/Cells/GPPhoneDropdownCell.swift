//
//  GPPhoneDropdownCell.swift
//  GamePaySDKCoreUI
//
//  Created by Luke Nguyen on 28/7/25.
//

import UIKit

class GPPhoneDropdownCell: GPHorizontalDropdownCell {
    private lazy var flagLabel: UILabel = {
        let label = UILabel()
        label.widthAnchor.constraint(equalToConstant: 32).isActive = true
        label.heightAnchor.constraint(equalToConstant: 32).isActive = true
        label.setContentHuggingPriority(.required, for: .horizontal)
        return label
    }()
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return label
    }()
    private lazy var codeLabel: UILabel = {
        let label = UILabel()
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        return label
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        flagLabel.text = nil
        titleLabel.text = nil
        codeLabel.text = nil
    }
    
    override func getSubviews() -> [UIView] {
        return [flagLabel, titleLabel, codeLabel]
    }
    
    override func configureCell(with option: GPDropdownOption, isSelectedCell: Bool, theme: GPTheme) {
        super.configureCell(with: option, isSelectedCell: isSelectedCell, theme: theme)
        guard let phoneOption = option as? GPPhoneDropdownOption else { return }

        flagLabel.text = phoneOption.flag
        codeLabel.text = phoneOption.phoneCode.map { "+\($0)" }
        titleLabel.text = phoneOption.name

        codeLabel.font = theme.typography.body1
        codeLabel.textColor = theme.colors.textSecondary
        titleLabel.font = theme.typography.body1

        divider.backgroundColor = theme.colors.borderSubtle
    }
}
