//
//  GPBaseTextField.swift
//  GamePaySDKCoreUI
//
//  Created by Luke Nguyen on 28/7/25.
//

import UIKit

public class GPBaseTextField: UIView, FormElementType {
    
    // MARK: - Properties
    let title: String
    public let theme: GPTheme
    
    /// Placeholder text (triggers `setPlaceholder` on update)
    public var placeholder: String {
        didSet { setPlaceholder() }
    }
    
    /// Optional input formatter for child text field(s)
    public var inputFormatter: TextFieldFormatter?
    
    /// Constant height for the text field container
    public let height: CGFloat = 48
    
    /// Text used for validation. Must be overridden by subclass.
    open var validationText: String {
        fatalError("Subclasses must override `validationText`.")
    }
    
    public var parentTextField: GPBaseTextField? {
        var view = superview
        while let current = view {
            if let textField = current as? GPBaseTextField {
                return textField
            }
            view = current.superview
        }
        return nil
    }
    var isError: Bool = false
    
    // MARK: - UI Elements
    private let mainStackView: UIStackView = {
        let stv = UIStackView()
        stv.axis = .vertical
        stv.spacing = 4
        return stv
    }()
    
    /// Stack that contains all text field(s)
    public lazy var tfStackView: UIStackView = {
        let stv = UIStackView()
        stv.spacing = 8
        stv.distribution = .fill
        stv.alignment = .fill
        stv.heightAnchor.constraint(equalToConstant: height).isActive = true
        return stv
    }()
    
    /// Title label shown above the text field(s)
    public lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = title
        label.font = theme.typography.label1
        label.textColor = theme.colors.textPrimary
        return label
    }()
    
    /// View to display validation or system error message
    public lazy var errorView = ErrorView(theme: theme)
    
    // MARK: - Initializers
    
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
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Setup
    private func setup() {
        setupLayout()
        setupTextFields()
        setPlaceholder()
    }
    
    private func setupLayout() {
        mainStackView.addArrangedSubview(titleLabel)
        mainStackView.addArrangedSubview(tfStackView)
        mainStackView.addArrangedSubview(errorView)
        
        addAndPinSubview(mainStackView)
      
        errorView.isHidden = true
    }
    
    /// Populates the `tfStackView` with views returned by `getChildViews()`
    private func setupTextFields() {
        for view in getChildViews() {
            tfStackView.addArrangedSubview(view)
        }
    }
    
    // MARK: - Overridable Methods
    /// Subclasses should override to return the field views (e.g., UITextField, PhoneTextField)
    open func getChildViews() -> [UIView] {
        return []
    }
    
    /// Subclasses can override to set placeholder to the appropriate field(s)
    open func setPlaceholder() { }
    
    // MARK: - Error Handler
    public func showError(message: String?) {
        guard !isError else { return }
        
        isError = true
        for subview in tfStackView.subviews {
            guard let subview = subview as? GPBaseTextField else { continue }
            subview.showError(message: nil)
        }
        
        if message != nil {
            errorView.setText(message)
            errorView.isHidden = false
            invalidateIntrinsicContentSize()
        }
    }
    
    public func hideError() {
        guard isError else { return }
        
        isError = false
        
        for subview in tfStackView.subviews {
            guard let subview = subview as? GPBaseTextField else { continue }
            subview.hideError()
        }
        
        if !errorView.isHidden {
            errorView.isHidden = true
            invalidateIntrinsicContentSize()
        }
        
        parentTextField?.hideError()
    }
    
    func applyBorder(to view: UIView, width: CGFloat, color: UIColor? = nil) {
        let action: () -> Void = { [weak self] in
            guard let self = self else { return }
            view.layer.borderWidth = width
            view.layer.borderColor = color?.cgColor ?? theme.colors.borderPrimary.cgColor
            view.layer.cornerRadius = theme.appearance.cornerRadius
        }
        
        UIView.transition(with: view, duration: 0.1, options: .transitionCrossDissolve, animations: action)
    }
}
