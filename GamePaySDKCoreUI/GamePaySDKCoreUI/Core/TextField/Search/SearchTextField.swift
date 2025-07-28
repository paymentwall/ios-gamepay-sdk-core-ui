//
//  SearchTextField.swift
//  GamePaySDKCoreUI
//
//  Created by Luke Nguyen on 28/7/25.
//

import UIKit

public class SearchTextField: UIView {

    // MARK: - Properties
    private let theme: GPTheme

    // MARK: - Subviews
    private let containerStack = UIStackView()
    private let searchIcon = UIImageView(image: GPAssets.icSearch.image.withRenderingMode(.alwaysTemplate))
    private let textField = UITextField()
    private let clearButton = UIButton(type: .system)

    // MARK: - Public Properties
    public var onTextChanged: ((String) -> Void)?
    public var onClearTapped: (() -> Void)?

    // MARK: - Init
    public init(theme: GPTheme) {
        self.theme = theme
        super.init(frame: .zero)
        setupView()
        setupLayout()
        setupBehavior()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setupView() {
        containerStack.axis = .horizontal
        containerStack.spacing = 8
        containerStack.alignment = .center
        containerStack.distribution = .fill
        containerStack.isLayoutMarginsRelativeArrangement = true
        containerStack.layoutMargins = .init(top: 0, left: theme.appearance.padding, bottom: 0, right: theme.appearance.padding)
        containerStack.layer.cornerRadius = theme.appearance.cornerRadius
        containerStack.layer.borderWidth = theme.appearance.borderWidth
        containerStack.layer.borderColor = theme.colors.borderPrimary.cgColor
        containerStack.backgroundColor = theme.colors.bgDefaultLight
        containerStack.translatesAutoresizingMaskIntoConstraints = false

        searchIcon.translatesAutoresizingMaskIntoConstraints = false
        searchIcon.contentMode = .scaleAspectFit
        searchIcon.tintColor = theme.colors.borderPrimary

        textField.attributedPlaceholder = NSAttributedString(
            string: "Search",
            attributes: [
                .foregroundColor: theme.colors.textSecondary,
                .font: theme.typography.body1
            ]
        )
        textField.font = theme.typography.body1
        textField.textColor = theme.colors.textPrimary
        textField.backgroundColor = .clear
        textField.borderStyle = .none
        textField.clearButtonMode = .never
        textField.translatesAutoresizingMaskIntoConstraints = false

        clearButton.setImage(GPAssets.icCloseNavBar.image, for: .normal)
        clearButton.tintColor = theme.colors.borderPrimary
        clearButton.translatesAutoresizingMaskIntoConstraints = false
        clearButton.isHidden = true

        addSubview(containerStack)
        containerStack.addArrangedSubview(searchIcon)
        containerStack.addArrangedSubview(textField)
        containerStack.addArrangedSubview(clearButton)
    }

    private func setupLayout() {
        NSLayoutConstraint.activate([
            containerStack.topAnchor.constraint(equalTo: topAnchor),
            containerStack.bottomAnchor.constraint(equalTo: bottomAnchor),
            containerStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerStack.trailingAnchor.constraint(equalTo: trailingAnchor),

            searchIcon.widthAnchor.constraint(equalToConstant: 24),
            searchIcon.heightAnchor.constraint(equalToConstant: 24),

            clearButton.widthAnchor.constraint(equalToConstant: 24),
            clearButton.heightAnchor.constraint(equalToConstant: 24),
            
            heightAnchor.constraint(equalToConstant: 48)
        ])
    }

    private func setupBehavior() {
        textField.addTarget(self, action: #selector(textChanged), for: .editingChanged)
        textField.addTarget(self, action: #selector(editingDidBegin), for: .editingDidBegin)
        textField.addTarget(self, action: #selector(editingDidEnd), for: .editingDidEnd)
        clearButton.addTarget(self, action: #selector(clearTapped), for: .touchUpInside)
    }

    // MARK: - Actions

    private func updateClearButtonVisibility(animated: Bool = true) {
        let shouldShow = !(textField.text ?? "").isEmpty
        
        guard clearButton.isHidden != !shouldShow else { return }
        
        if animated {
            UIView.performWithoutAnimation {
                UIView.transition(with: clearButton, duration: 0.25, options: .transitionCrossDissolve) {
                    self.clearButton.isHidden = !shouldShow
                    self.containerStack.layoutIfNeeded() // Ensure smooth layout change
                }
            }
        } else {
            clearButton.isHidden = !shouldShow
        }
    }

    @objc private func textChanged() {
        updateClearButtonVisibility()
        onTextChanged?(textField.text ?? "")
    }

    @objc private func clearTapped() {
        textField.text = ""
        updateClearButtonVisibility()
        onTextChanged?("")
        onClearTapped?()
    }

    @objc private func editingDidBegin() {
        applyBorder(width: 2)
    }

    @objc private func editingDidEnd() {
        applyBorder(width: 1)
    }

    private func applyBorder(width: CGFloat, color: UIColor? = nil) {
        containerStack.layer.borderWidth = width
        containerStack.layer.borderColor = color?.cgColor ?? theme.colors.borderPrimary.cgColor
    }

    // MARK: - Public API

    public func setText(_ text: String) {
        textField.text = text
        textChanged()
    }

    public func becomeActive() {
        textField.becomeFirstResponder()
    }

    public func resignActive() {
        textField.resignFirstResponder()
    }

    public func getText() -> String {
        return textField.text ?? ""
    }
}
