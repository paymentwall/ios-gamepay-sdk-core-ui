//
//  BaseTextField.swift
//  GamePaySDKCoreUI
//
//  Created by Luke Nguyen on 28/7/25.
//

import UIKit

public class BaseTextField: UIView, FormElementType {
    private let title: String
    let theme: GPTheme
    var placeholder: String {
        didSet { setPlaceholder() }
    }
    var inputFormatter: TextFieldFormatter?
    let height: CGFloat = 48
    
    // MARK: - UI Properties
    private var mainStackView = UIStackView()
    var tfStackView = UIStackView()
    let titleLabel = UILabel()
    lazy var errorView = ErrorView(theme: theme)
    
    open var validationText: String { return "" }
    
    // MARK: - Init
    public init(
        title: String,
        placeholder: String,
        formatter: TextFieldFormatter? = nil,
        theme: GPTheme
    ) {
        self.title = title
        self.placeholder = placeholder
        self.inputFormatter = formatter
        self.theme = theme
        super.init(frame: .zero)
        setPlaceholder()
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        tfStackView.spacing = 8
        
        mainStackView = UIStackView(arrangedSubviews: [titleLabel, tfStackView, errorView])
        mainStackView.axis = .vertical
        mainStackView.spacing = 4
        addAndPinSubview(mainStackView)
        
        titleLabel.text = title
        titleLabel.font = theme.typography.label1
        titleLabel.textColor = theme.colors.textPrimary
        
        tfStackView.heightAnchor.constraint(equalToConstant: height).isActive = true
        
        errorView.isHidden = true
    }
    
    open func setPlaceholder() { }
}

// MARK: - ErrorMessageProvider
extension BaseTextField {
    public func showError(message: String?) {
        for subview in tfStackView.subviews {
            applyBorder(view: subview, width: 2, color: theme.colors.borderError)
        }
        errorView.setText(message)
        errorView.isHidden = false
        invalidateIntrinsicContentSize()
    }
    
    public func hideError() {
        for subview in tfStackView.subviews {
            applyBorder(view: subview, width: theme.appearance.borderWidth)
        }
        errorView.isHidden = true
        invalidateIntrinsicContentSize()
    }
    
    func clearErrorIfNeeded() {
        if !errorView.isHidden {
            hideError()
        }
    }
    
    func applyBorder(view: UIView, width: CGFloat, color: UIColor? = nil) {
        let action: () -> Void = { [weak self] in
            guard let self = self else { return }
            view.layer.borderWidth = width
            view.layer.borderColor = color?.cgColor ?? theme.colors.borderPrimary.cgColor
        }
        
        UIView.transition(with: view, duration: 0.1, options: .transitionCrossDissolve, animations: action)
    }
}
