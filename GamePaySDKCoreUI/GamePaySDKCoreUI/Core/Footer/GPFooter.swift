//
//  GPFooter.swift
//  GamePaySDKCoreUI
//
//  Created by henry on 8/1/25.
//

import UIKit

open class GPFooter: UIView {
    
    // MARK: - Properties
    private let logoImage: UIImage
    private let termsURL: URL
    private let privacyURL: URL
    private let theme: GPTheme
    
    // MARK: - UI Components
    private lazy var divider = GPDivider()
    private lazy var logoImageView: UIImageView = {
        let logoImageView = UIImageView()
        logoImageView.image = logoImage
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.setSize(.init(width: 120, height: 24))
        return logoImageView
    }()
    private lazy var poweredByLabel: GPLabel2Label = {
        let label = GPLabel2Label(theme: theme)
        label.text = "Powered by "
        return label
    }()
    private lazy var termsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Terms", for: .normal)
        button.titleLabel?.font = theme.typography.label2
        button.tintColor = theme.colors.textPrimary
        button.addTarget(self, action: #selector(termsButtonTapped), for: .touchUpInside)
        return button
    }()
    private lazy var privacyButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Privacy", for: .normal)
        button.titleLabel?.font = theme.typography.label2
        button.tintColor = theme.colors.textPrimary
        button.addTarget(self, action: #selector(privacyButtonTapped), for: .touchUpInside)
        return button
    }()
    private lazy var separatorView: UIView = {
        let separatorView = UIView()
        separatorView.backgroundColor = theme.colors.textPrimary
        separatorView.setSize(.init(width: 1, height: 24))
        return separatorView
    }()
    private lazy var mainStackView: UIStackView = {
        let mainStackView = UIStackView()
        mainStackView.axis = .vertical
        mainStackView.spacing = 16
        mainStackView.alignment = .center
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.addArrangedSubview(divider)
        mainStackView.addArrangedSubview(contentStackView)
        return mainStackView
    }()
    
    private lazy var contentStackView: UIStackView = {
        let contentStackView = UIStackView()
        contentStackView.axis = .horizontal
        contentStackView.spacing = 8
        contentStackView.alignment = .center
        contentStackView.distribution = .fill
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        contentStackView.addArrangedSubview(poweredByLabel)
        contentStackView.addArrangedSubview(logoImageView)
        contentStackView.addArrangedSubview(separatorView)
        contentStackView.addArrangedSubview(termsButton)
        contentStackView.addArrangedSubview(privacyButton)
        return contentStackView
    }()
    
    // MARK: - Initialization
    public init(logoImage: UIImage, termsURL: URL, privacyURL: URL, theme: GPTheme) {
        self.logoImage = logoImage
        self.termsURL = termsURL
        self.privacyURL = privacyURL
        self.theme = theme
        super.init(frame: .zero)
        commonInit()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    private func commonInit() {
        addAndPinSubview(mainStackView, insets: .init(top: 0, leading: 0, bottom: 16, trailing: 0))
        NSLayoutConstraint.activate([
            divider.leadingAnchor.constraint(equalTo: mainStackView.leadingAnchor),
            divider.trailingAnchor.constraint(equalTo: mainStackView.trailingAnchor)
        ])
    }
    
    // MARK: - Actions
    @objc private func termsButtonTapped() {
        openURL(termsURL)
    }
    
    @objc private func privacyButtonTapped() {
        openURL(privacyURL)
    }
    
    private func openURL(_ url: URL) {
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
} 
