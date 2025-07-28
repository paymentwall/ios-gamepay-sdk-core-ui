//
//  DropdownOptionCell.swift
//  GamePaySDKCoreUI
//
//  Created by Luke Nguyen on 25/7/25.
//

import UIKit

class DropdownOptionCell: UITableViewCell {
    // Shared views
    private let iconView = UIImageView()
    private let selectedIconView = UIImageView()
    
    // Phone layout views
    private let flagLabel = UILabel()
    private let codeLabel = UILabel()
    
    // Common
    private let titleLabel = UILabel()
    private let divider = UIView()
    
    let stackView = UIStackView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupStackView()
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupStackView() {
        stackView.axis = .horizontal
        stackView.spacing = 12
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false

        addSubview(stackView)
        NSLayoutConstraint.activate([
            // TODO: Update defaultPadding
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ])
        
        divider.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(divider)
        NSLayoutConstraint.activate([
            divider.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            divider.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            divider.bottomAnchor.constraint(equalTo: bottomAnchor),
            divider.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
    
    private func setupView() {
        iconView.translatesAutoresizingMaskIntoConstraints = false
        iconView.contentMode = .scaleAspectFit
        selectedIconView.translatesAutoresizingMaskIntoConstraints = false
        selectedIconView.image = GPAssets.icCheckmark.image
        selectedIconView.setContentHuggingPriority(.required, for: .horizontal)
        
        flagLabel.translatesAutoresizingMaskIntoConstraints = false
        flagLabel.setContentHuggingPriority(.required, for: .horizontal)
        flagLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        codeLabel.translatesAutoresizingMaskIntoConstraints = false
        codeLabel.setContentHuggingPriority(.required, for: .horizontal)
        codeLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.numberOfLines = 0
        titleLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        NSLayoutConstraint.activate([
            iconView.widthAnchor.constraint(equalToConstant: 32),
            iconView.heightAnchor.constraint(equalToConstant: 32),
            flagLabel.widthAnchor.constraint(equalToConstant: 32),
            flagLabel.heightAnchor.constraint(equalToConstant: 32),
            selectedIconView.widthAnchor.constraint(equalToConstant: 24),
            selectedIconView.heightAnchor.constraint(equalToConstant: 24)
        ])
    }

    func configureSubviews(_ subviews: [UIView]) {
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        subviews.forEach { stackView.addArrangedSubview($0) }
    }
    
    // MARK: - Configure for Icon Text Cell
    func configure(with option: DropdownOption, theme: GPTheme, isSelected: Bool) {
        // Clear previous arranged views
        stackView.arrangedSubviews.forEach { stackView.removeArrangedSubview($0); $0.removeFromSuperview() }
        
        titleLabel.text = option.name
        titleLabel.font = theme.typography.body1
        iconView.image = nil
        if let logoUrl = option.logoUrl {
            iconView.loadImage(from: logoUrl)
        }
        selectedIconView.isHidden = !isSelected
        
        divider.backgroundColor = theme.colors.borderSubtle
        
        stackView.addArrangedSubview(iconView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(selectedIconView)
    }
    
    // MARK: - Configure for Phone Cell
    func configure(with option: DropdownPhoneOption, theme: GPTheme) {
        // Clear previous arranged views
        stackView.arrangedSubviews.forEach { stackView.removeArrangedSubview($0); $0.removeFromSuperview() }
        
        flagLabel.text = option.flag
        codeLabel.text = option.phoneCode.map { "+\($0)" }
        codeLabel.font = theme.typography.body1
        codeLabel.textColor = theme.colors.textSecondary
        
        titleLabel.text = option.name
        titleLabel.font = theme.typography.body1
        
        divider.backgroundColor = theme.colors.borderSubtle
        
        stackView.addArrangedSubview(flagLabel)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(codeLabel)
    }
}
