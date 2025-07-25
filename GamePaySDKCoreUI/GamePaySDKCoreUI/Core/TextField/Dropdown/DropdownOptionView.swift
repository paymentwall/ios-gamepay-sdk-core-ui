//
//  DropdownOptionView.swift
//  GamePaySDKCoreUI
//
//  Created by Luke Nguyen on 25/7/25.
//

import UIKit

protocol DropdownOptionViewDelegate: AnyObject {
    func didSelectOption(_ option: DropdownOption)
}

class DropdownOptionView: UIView {
    var option: DropdownOption?
    weak var delegate: DropdownOptionViewDelegate?
    let theme: GPTheme
    let mainStackView = UIStackView()

    init(theme: GPTheme) {
        self.theme = theme
        super.init(frame: .zero)
        setupMainStackView()
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupMainStackView() {
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
        divider.backgroundColor = theme.colors.borderSubtle
        
        addSubview(divider)
        NSLayoutConstraint.activate([
            divider.leadingAnchor.constraint(equalTo: mainStackView.leadingAnchor),
            divider.trailingAnchor.constraint(equalTo: mainStackView.trailingAnchor),
            divider.bottomAnchor.constraint(equalTo: bottomAnchor),
            divider.heightAnchor.constraint(equalToConstant: 1)
        ])
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        addGestureRecognizer(gesture)
    }
    
    // Custom setup 
    open func setupView() { }

    func configureSubviews(_ subviews: [UIView]) {
        mainStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        subviews.forEach { mainStackView.addArrangedSubview($0) }
    }
    
    @objc func handleTap() {
        guard let option else { return }
        delegate?.didSelectOption(option)
    }
}
