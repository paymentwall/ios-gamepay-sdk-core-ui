//
//  DropdownOptionCell.swift
//  GamePaySDKCoreUI
//
//  Created by Luke Nguyen on 25/7/25.
//

import UIKit

class DropdownOptionCell: UITableViewCell {
    let mainStackView = UIStackView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureCell()
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureCell() {
        mainStackView.axis = .horizontal
        mainStackView.spacing = 12
        mainStackView.alignment = .center
        mainStackView.translatesAutoresizingMaskIntoConstraints = false

        addSubview(mainStackView)
        NSLayoutConstraint.activate([
            // TODO: Update defaultPadding
            mainStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            mainStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            mainStackView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            mainStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ])
        
        // Divider view
        let divider = UIView()
        divider.translatesAutoresizingMaskIntoConstraints = false
//        divider.backgroundColor = theme.colors.borderSubtle
        
        addSubview(divider)
        NSLayoutConstraint.activate([
            divider.leadingAnchor.constraint(equalTo: mainStackView.leadingAnchor),
            divider.trailingAnchor.constraint(equalTo: mainStackView.trailingAnchor),
            divider.bottomAnchor.constraint(equalTo: bottomAnchor),
            divider.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
    
    // Custom setup
    open func setupView() { }

    func configureSubviews(_ subviews: [UIView]) {
        mainStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        subviews.forEach { mainStackView.addArrangedSubview($0) }
    }
}
