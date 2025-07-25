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

// MARK: - Custom TextField with Validation
public class FormTextField: UIView, FormElementType {
    // MARK: - Properties
    let theme: Theme
    private let title: String
    let textField = UITextField()
    var text: String { textField.text ?? "" }
    open var validationText: String { text }
    var placeholder: String {
        didSet { setPlaceholder() }
    }
    var inputFormatter: TextFieldFormatter?
    var onTextChanged: ((String) -> Void)?
    var onShouldReturn: (() -> Bool)?
    var validator: Validator?
    
    // MARK: - UI Properties
    private let titleLabel = UILabel()
    private lazy var errorLabel: UILabel = {
        let errorLabel = UILabel()
        errorLabel.font = errorFont
        errorLabel.textColor = theme.colors.borderError
        errorLabel.numberOfLines = 0
        return errorLabel
    }()
    private lazy var errorView: UIView = {
        let icon = UIImageView(image: GPAssets.icWarning.image)
        let view = UIStackView(arrangedSubviews: [icon, errorLabel])
        view.spacing = 4
        return view
    }()
    private var titleFont: UIFont {
        theme.typography.label1
    }
    var errorFont: UIFont {
        theme.typography.label2
    }
    var defaultFont: UIFont {
        theme.typography.body1
    }
    
    // MARK: - Init
    public init(
        title: String,
        placeholder: String,
        formatter: TextFieldFormatter? = nil,
        theme: Theme
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
        setupLayout()
        setupEvents()
        setupView()
    }
    
    private func setupLayout() {
        let stack = UIStackView(arrangedSubviews: [titleLabel, textField, errorView])
        stack.axis = .vertical
        stack.spacing = 4
        addAndPinSubview(stack)
        
        titleLabel.text = title
        titleLabel.font = titleFont
        titleLabel.textColor = theme.colors.textPrimary
        
        textField.textColor = theme.colors.textPrimary
        textField.backgroundColor = theme.colors.bgDefaultLight
        textField.font = defaultFont
        textField.borderStyle = .none
        // TODO: Update borderWidth
        textField.layer.borderWidth = 1
        textField.layer.borderColor = theme.colors.borderPrimary.cgColor
        textField.layer.cornerRadius = theme.appearance.cornerRadius
        // TODO: Update defaultPadding
        textField.setPaddingPoints(16, side: .Both)
        // TODO: Update componentHeight
        textField.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
        errorView.isHidden = true
    }
    
    private func setupEvents() {
        textField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        textField.addTarget(self, action: #selector(editingDidBegin), for: .editingDidBegin)
        textField.addTarget(self, action: #selector(editingDidEnd), for: .editingDidEnd)
        textField.delegate = self
    }
    
    // Setup view for inheritance
    open func setupView() { }
    
    private func setPlaceholder() {
        textField.attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [
                .foregroundColor: theme.colors.textSecondary,
                .font: defaultFont
            ]
        )
    }
    
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
        imageView.loadImage(from: imageUrl)

        applyIconView(imageView, on: side, animated: animated)
    }

    func applyIconView(
        _ imageView: UIImageView,
        on side: TextFieldSide,
        animated: Bool
    ) {
        let container = setupImageView(imageView, side)

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
    private func setupImageView(_ imageView: UIImageView, _ side: TextFieldSide) -> UIView {
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.widthAnchor.constraint(equalToConstant: 24).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 24).isActive = true

        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(imageView)

        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            container.widthAnchor.constraint(equalToConstant: 40),
            container.heightAnchor.constraint(equalToConstant: 48)
        ])

        return container
    }
    
    @objc func textDidChange() {
        clearErrorIfNeeded()
        onTextChanged?(textField.text ?? "")
    }
    
    @objc func editingDidBegin() {
        clearErrorIfNeeded()
        // TODO: Update selectedBorderWidth
        applyBorder(width: 2)
    }
    
    @objc func editingDidEnd() {
        // TODO: Update borderWidth
        applyBorder(width: 1)
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

// MARK: - ErrorMessageProvider
extension FormTextField {
    public func showError(message: String?) {
        // TODO: Update selectedBorderWidth
        applyBorder(width: 3, color: theme.colors.borderError)
        errorLabel.text = message
        errorView.isHidden = false
        invalidateIntrinsicContentSize()
    }
    
    public func hideError() {
        // TODO: Update borderWidth
        applyBorder(width: 1)
        errorView.isHidden = true
        invalidateIntrinsicContentSize()
    }
    
    private func clearErrorIfNeeded() {
        if !errorView.isHidden {
            hideError()
        }
    }
    
    private func applyBorder(width: CGFloat, color: UIColor? = nil) {
        textField.layer.borderWidth = width
        textField.layer.borderColor = color?.cgColor ?? theme.colors.borderPrimary.cgColor
    }
}
