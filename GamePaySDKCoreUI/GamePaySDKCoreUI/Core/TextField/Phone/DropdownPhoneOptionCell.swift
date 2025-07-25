//
//  DropdownPhoneOptionCell.swift
//  GamePaySDKCoreUI
//
//  Created by Luke Nguyen on 25/7/25.
//

import UIKit

class DropdownPhoneOptionCell: DropdownOptionCell {
    private let flagLabel = UILabel()
    private let codeLabel = UILabel()
    private let titleLabel = UILabel()
    
    override func setupView() {
        flagLabel.translatesAutoresizingMaskIntoConstraints = false
        codeLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
    }

    func configure(with option: DropdownPhoneOption, theme: GPTheme) {
        flagLabel.text = option.flag
        codeLabel.text = option.phoneCode.map { "+\($0)" }
        codeLabel.font = theme.typography.body1
        codeLabel.textColor = theme.colors.textSecondary
        titleLabel.text = option.name
        titleLabel.font = theme.typography.body1
        flagLabel.setContentHuggingPriority(.required, for: .horizontal)
        codeLabel.setContentHuggingPriority(.required, for: .horizontal)
        configureSubviews([flagLabel, titleLabel, codeLabel])
    }
}

