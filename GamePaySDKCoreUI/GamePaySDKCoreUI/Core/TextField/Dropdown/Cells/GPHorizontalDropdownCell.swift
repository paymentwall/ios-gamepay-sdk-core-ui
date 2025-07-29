//
//  GPHorizontalDropdownCell.swift
//  GamePaySDKCoreUI
//
//  Created by Luke Nguyen on 29/7/25.
//

import UIKit

class GPHorizontalDropdownCell: GPBaseDropdownCell {
    let stackView = UIStackView()
    let divider = UIView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLayout() {
        stackView.axis = .horizontal
        stackView.spacing = 12
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        divider.translatesAutoresizingMaskIntoConstraints = false
      
        addSubview(stackView)
        addSubview(divider)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            
            divider.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            divider.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            divider.bottomAnchor.constraint(equalTo: bottomAnchor),
            divider.heightAnchor.constraint(equalToConstant: 1)
        ])
    }

    func setupView() {
        for view in getSubviews() {
            stackView.addArrangedSubview(view)
        }
    }
    
    /// Subclasses must override getSubviews() to return arranged subviews.
    func getSubviews() -> [UIView] {
        fatalError("Subclasses must override getSubviews() to return arranged subviews.")
    }
}
