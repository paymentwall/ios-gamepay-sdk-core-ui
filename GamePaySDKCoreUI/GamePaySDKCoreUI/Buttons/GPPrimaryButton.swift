//
//  GPPrimaryButton.swift
//  GamePaySDKCoreUI
//
//  Created by henry on 7/25/25.
//

import UIKit

public class GPPrimaryButton: GPBaseButton {
    
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
        lblTitle.font = theme.typography.button1
        switch state {
        case .active:
            backgroundColor = theme.colors.bgDefaultDark
            lblTitle.textColor = theme.colors.textButtonLight
        case .inactive:
            backgroundColor = theme.colors.bgInactive
            lblTitle.textColor = theme.colors.textButtonInactivePrimary
        case .loading, .success:
            backgroundColor = theme.colors.bgDefaultDark
        }
    }
    
    func config(title: String? = nil, icon: UIImage? = nil, onTap: () -> Void) {
//        setup(title: title, icon: icon, )
    }
}
