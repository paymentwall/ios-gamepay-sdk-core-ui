import UIKit

extension UIViewController {
    
    public func showDropDownMessage(
        title: String,
        message: String,
        type: DropDownMessageView.MessageType,
        theme: GPTheme,
        duration: TimeInterval = 5.0,
        onTapMessage: (() -> Void)? = nil,
        onTapClose: (() -> Void)? = nil
    ) {
        let messageView = DropDownMessageView(
            title: title, 
            message: message, 
            type: type, 
            theme: theme) { [weak self] messageView in
                self?.dismissDropDownMessage(messageView)
                onTapMessage?()
            } onTapClose: { [weak self] messageView in
                self?.dismissDropDownMessage(messageView)
                onTapClose?()
            }
        messageView.translatesAutoresizingMaskIntoConstraints = false
        
        // Add to view hierarchy
        view.addSubview(messageView)
        
        // Set initial position (off-screen at top)
        NSLayoutConstraint.activate([
            messageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: theme.appearance.padding),
            messageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -theme.appearance.padding),
            messageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: -200), // Start off-screen
        ])
        
        view.layoutIfNeeded()
        
        // Animate in
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: .curveEaseOut) {
            messageView.transform = CGAffineTransform(translationX: 0, y: 200)
        }
        
        // Auto dismiss after duration
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            self.dismissDropDownMessage(messageView)
        }
    }
    
    private func dismissDropDownMessage(_ messageView: DropDownMessageView) {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn) {
            messageView.transform = CGAffineTransform(translationX: 0, y: -200)
            messageView.alpha = 0
        } completion: { _ in
            messageView.removeFromSuperview()
        }
    }
}

// MARK: - DropDownMessageView
public class DropDownMessageView: UIView {
    
    public enum MessageType {
        case info, success, warning, error
    }
    
    public typealias Completion = (DropDownMessageView) -> Void
    
    // MARK: - UI Elements
    private lazy var lblTitle: UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 0
        return lbl
    }()
    private lazy var lblMessage: UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 0
        return lbl
    }()
    private lazy var ivIcon: UIImageView = {
        let iv = UIImageView()
        iv.setSize(.init(width: 24, height: 24))
        return iv
    }()
    private lazy var closeButton: UIView = {
        let closeButton = GPQuaternaryButton(theme: theme)
        closeButton.config(icon: GPAssets.icCloseNavBar.image) { [weak self] in
            self?.closeButtonTapped()
        }
        closeButton.setSize(.init(width: 32, height: 32))
        return closeButton
    }()
    private lazy var stvTitleContainer: UIStackView = {
        let stv = UIStackView(arrangedSubviews: [lblTitle, closeButton])
        stv.axis = .horizontal
        stv.spacing = 8
        return stv
    }()
    private lazy var stvContentContainer: UIStackView = {
        let stv = UIStackView(arrangedSubviews: [stvTitleContainer, lblMessage])
        stv.axis = .vertical
        stv.spacing = 0
        return stv
    }()
    private lazy var stvContainer: UIStackView = {
        let stv = UIStackView(arrangedSubviews: [ivIcon, stvContentContainer])
        stv.axis = .horizontal
        stv.spacing = 16
        stv.alignment = .center
        return stv
    }()
    
    // MARK: - Properties
    private let title: String
    private let message: String
    private let type: MessageType
    private let theme: GPTheme
    private let onTapMessage: Completion?
    private let onTapClose: Completion?
    
    // MARK: - Lifecycles
    init(title: String, message: String, type: MessageType, theme: GPTheme, onTapMessage: Completion? = nil, onTapClose: Completion? = nil) {
        self.title = title
        self.message = message
        self.type = type
        self.theme = theme
        self.onTapMessage = onTapMessage
        self.onTapClose = onTapClose
        super.init(frame: .zero)
        setupUI()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        addGestureRecognizer(tap)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Set up
    private func setupUI() {
        // set up constraints
        addAndPinSubview(stvContainer, insets: theme.appearance.formInsets)
        
        // set up style
        layer.cornerRadius = theme.appearance.cornerRadius
        lblTitle.font = theme.typography.bodyMedium2
        lblTitle.textColor = theme.colors.textPrimary
        lblMessage.font = theme.typography.body1
        lblMessage.textColor = theme.colors.textPrimary
        closeButton.tintColor = theme.colors.textPrimary
        switch type {
        case .info:
            backgroundColor = theme.colors.bgInfo
            ivIcon.image = GPAssets.icInfo.image
        case .success:
            backgroundColor = theme.colors.bgSuccess
            ivIcon.image = GPAssets.ic_success.image
        case .warning:
            backgroundColor = theme.colors.bgWarning
            ivIcon.image = GPAssets.icWarning.image
        case .error:
            backgroundColor = theme.colors.bgError
            ivIcon.image = GPAssets.icError.image
        }
        
        // set up data
        lblTitle.text = title
        lblMessage.text = message
    }
    
    @objc private func handleTap() {
        onTapMessage?(self)
    }
    
    @objc private func closeButtonTapped() {
        onTapClose?(self)
    }
}
