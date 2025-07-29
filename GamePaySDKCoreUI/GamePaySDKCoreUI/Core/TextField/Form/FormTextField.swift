//
//  FormTextField.swift
//  GamePaySDKCoreUI
//
//  Created by Luke Nguyen on 24/7/25.
//

import UIKit

enum TextFieldSide {
    case Left, Right, Both
}

public class FormTextField: BaseTextField {
    // MARK: - Public Properties
    public var onTextChanged: ((String) -> Void)?
    public var onShouldReturn: (() -> Bool)?
    public var validator: Validator?
    public var text: String { textField.text ?? "" }
    
    public override var validationText: String {
        inputFormatter?.unformatted(text) ?? text
    }
    
    // MARK: - UI Properties
    let textField = UITextField()
    
    // MARK: - Init
    public override init(
        title: String,
        placeholder: String,
        formatter: TextFieldFormatter? = nil,
        theme: GPTheme
    ) {
        super.init(title: title, placeholder: placeholder, formatter: formatter, theme: theme)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        setupLayout()
        setupEvents()
    }
    
    private func setupLayout() {
        tfStackView.addArrangedSubview(textField)
        
        textField.textColor = theme.colors.textPrimary
        textField.backgroundColor = theme.colors.bgDefaultLight
        textField.font = theme.typography.body1
        textField.borderStyle = .none
        textField.layer.borderWidth = theme.appearance.borderWidth
        textField.layer.borderColor = theme.colors.borderPrimary.cgColor
        textField.layer.cornerRadius = theme.appearance.cornerRadius
        textField.setPaddingPoints(theme.appearance.padding, side: .Both)
    }
    
    private func setupEvents() {
        textField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        textField.addTarget(self, action: #selector(editingDidBegin), for: .editingDidBegin)
        textField.addTarget(self, action: #selector(editingDidEnd), for: .editingDidEnd)
        textField.delegate = self
    }
    
    public override func setPlaceholder() {
        textField.attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [
                .foregroundColor: theme.colors.textSecondary,
                .font: theme.typography.body1
            ]
        )
    }
    
    // MARK: - Public APIs
    func setText(_ text: String) {
        textField.text = text
    }
    
    func setIcon(
        _ image: UIImage?,
        on side: TextFieldSide,
        useTemplate: Bool = true,
        animated: Bool = false
    ) {
        guard let image else { return }

        // Avoid updating if the same image is already set
        let currentContainer = side == .Left ? textField.leftView : textField.rightView
        if let existingImageView = currentContainer?.subviews.first as? UIImageView,
           existingImageView.image?.pngData() == image.pngData() {
            return
        }

        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = useTemplate ? image.withRenderingMode(.alwaysTemplate) : image
        imageView.tintColor = theme.colors.borderPrimary

        applyIconView(imageView, on: side, animated: animated)
    }

    func setIcon(
        from imageUrl: String,
        on side: TextFieldSide,
        animated: Bool = false
    ) {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.loadImage(from: imageUrl)

        applyIconView(imageView, on: side, animated: animated)
    }

    func applyIconView(
        _ view: UIView,
        on side: TextFieldSide,
        animated: Bool
    ) {
        let container = setupViewWithContainer(view, side)

        let applyView = {
            self.textField.setViewBySide(container, side)
        }

        if animated {
            UIView.transition(
                with: textField,
                duration: 0.25,
                options: .transitionCrossDissolve,
                animations: applyView,
                completion: nil
            )
        } else {
            applyView()
        }
    }
    
    @discardableResult
    private func setupViewWithContainer(_ view: UIView, _ side: TextFieldSide) -> UIView {
        view.translatesAutoresizingMaskIntoConstraints = false
        view.widthAnchor.constraint(equalToConstant: 24).isActive = true
        view.heightAnchor.constraint(equalToConstant: 24).isActive = true

        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)

        NSLayoutConstraint.activate([
            view.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            view.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            container.widthAnchor.constraint(equalToConstant: 40),
            container.heightAnchor.constraint(equalToConstant: height)
        ])

        return container
    }
    
    @objc func textDidChange() {
        clearErrorIfNeeded()
        onTextChanged?(textField.text ?? "")
    }
    
    @objc func editingDidBegin() {
        clearErrorIfNeeded()
        applyBorder(view: textField, width: 2)
    }
    
    @objc func editingDidEnd() {
        applyBorder(view: textField, width: theme.appearance.borderWidth)
    }
}

extension FormTextField: UITextFieldDelegate {
    open func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let currentText = textField.text,
              let stringRange = Range(range, in: currentText),
              let formatter = inputFormatter else {
            return true
        }
        
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        let raw = formatter.unformatted(updatedText)
        
        if raw.count > formatter.maxLength {
            return false
        }
        
        textField.text = formatter.format(raw)
        textField.sendActions(for: .editingChanged)
        return false
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return onShouldReturn?() ?? true
    }
}
