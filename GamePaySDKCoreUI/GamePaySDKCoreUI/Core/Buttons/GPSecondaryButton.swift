import UIKit

public class GPSecondaryButton: GPBaseButton {
    // MARK: - Properties
    private let theme: GPTheme
    public var isOutlined: Bool = false {
        didSet {
            doStyle(for: state)
        }
    }
    
    // MARK: - Object lifecycles
    public init(theme: GPTheme) {
        self.theme = theme
        super.init(frame: .zero)
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Set up
    override func doStyle(for state: GPBaseButton.State) {
        layer.cornerRadius = theme.appearance.cornerRadius
        lblTitle.font = theme.typography.button1
        backgroundColor = .clear
        if isOutlined {
            layer.borderWidth = theme.appearance.borderWidth
            layer.borderColor = theme.colors.borderSubtle.cgColor
        } else {
            layer.borderWidth = 0
        }
        switch state {
        case .active:
            lblTitle.textColor = theme.colors.textButtonDark
            imvIcon.tintColor = theme.colors.textButtonDark
        case .inactive:
            lblTitle.textColor = theme.colors.textButtonInactiveSecondary
            imvIcon.tintColor = theme.colors.textButtonInactiveSecondary
        case .loading, .success:
            break
        }
    }
    
    override func getHeight() -> CGFloat? {
        54
    }
}
