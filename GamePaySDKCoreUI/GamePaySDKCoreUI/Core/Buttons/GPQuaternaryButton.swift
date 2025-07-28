import UIKit

public class GPQuaternaryButton: GPBaseButton {
    // MARK: - Properties
    private let theme: GPTheme
    
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
        lblTitle.font = theme.typography.bodyCompact1
        backgroundColor = .clear
        switch state {
        case .active:
            lblTitle.textColor = theme.colors.bgDefaultDark
            imvIcon.tintColor = theme.colors.bgDefaultDark
        case .inactive:
            lblTitle.textColor = theme.colors.textButtonInactiveSecondary
            imvIcon.tintColor = theme.colors.textButtonInactiveSecondary
        case .loading, .success:
            break
        }
    }
} 
