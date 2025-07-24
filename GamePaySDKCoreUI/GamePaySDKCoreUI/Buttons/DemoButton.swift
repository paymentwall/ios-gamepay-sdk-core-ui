//
//  DemoButton.swift
//  GamePaySDKCoreUI
//
//  Created by henry on 7/24/25.
//

import UIKit

public class DemoButton: UIButton {
    var theme: Theme!
    
    public init(theme: Theme) {
        self.theme = theme
        super.init(frame: .zero)
        applyTheme()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func applyTheme() {
        heightAnchor.constraint(equalToConstant: 54).isActive = true
        layer.cornerRadius = theme.appearance.cornerRadius
        backgroundColor = theme.colors.bgDefaultDark
        setTitleColor(theme.colors.textButtonLight, for: .normal)
        titleLabel?.font = theme.typography.button1
    }
}
