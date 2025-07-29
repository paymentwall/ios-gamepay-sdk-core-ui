//
//  PhoneDropdownCell.swift
//  GamePaySDKCoreUI
//
//  Created by Luke Nguyen on 28/7/25.
//

import UIKit

class PhoneDropdownCell: HorizontalDropdownCell {
    private let flagLabel = UILabel()
    private let titleLabel = UILabel()
    private let codeLabel = UILabel()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        flagLabel.text = nil
        titleLabel.text = nil
        codeLabel.text = nil
    }

    override func setupView() {
        flagLabel.widthAnchor.constraint(equalToConstant: 32).isActive = true
        flagLabel.heightAnchor.constraint(equalToConstant: 32).isActive = true
        flagLabel.setContentHuggingPriority(.required, for: .horizontal)

        codeLabel.setContentHuggingPriority(.required, for: .horizontal)
        codeLabel.setContentCompressionResistancePriority(.required, for: .horizontal)

        titleLabel.numberOfLines = 0
        titleLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)

        stackView.addArrangedSubview(flagLabel)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(codeLabel)
    }

    override func configureCell(with option: DropdownOption, theme: GPTheme) {
        super.configureCell(with: option, theme: theme)
        guard let phoneOption = option as? PhoneDropdownOption else { return }

        flagLabel.text = phoneOption.flag
        codeLabel.text = phoneOption.phoneCode.map { "+\($0)" }
        titleLabel.text = phoneOption.name

        codeLabel.font = theme.typography.body1
        codeLabel.textColor = theme.colors.textSecondary
        titleLabel.font = theme.typography.body1

        divider.backgroundColor = theme.colors.borderSubtle
    }
}
