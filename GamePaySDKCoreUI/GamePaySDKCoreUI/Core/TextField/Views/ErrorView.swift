//
//  ErrorView.swift
//  GamePaySDKCoreUI
//
//  Created by Luke Nguyen on 28/7/25.
//

import UIKit

final class ErrorView: UIView {
    private let iconImageView: UIImageView = {
        let imageView = UIImageView(image: GPAssets.icError.image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let errorLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    init(theme: GPTheme) {
        super.init(frame: .zero)
        errorLabel.font = theme.typography.label2
        errorLabel.textColor = theme.colors.borderError
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        let stack = UIStackView(arrangedSubviews: [iconImageView, errorLabel])
        stack.axis = .horizontal
        stack.spacing = 4
        stack.alignment = .top
        stack.translatesAutoresizingMaskIntoConstraints = false

        addSubview(stack)
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: topAnchor),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }

    func setText(_ text: String?) {
        errorLabel.text = text
    }
}
