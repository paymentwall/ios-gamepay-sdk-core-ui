//
//  GPBaseLabel.swift
//  GamePaySDKCoreUI
//
//  Created by henry on 8/1/25.
//

import UIKit

/// This is abstract class
public class GPBaseLabel: UILabel {
    
    // MARK: - Properties
    let theme: GPTheme
    
    // MARK: - Initialization
    public init(theme: GPTheme) {
        self.theme = theme
        super.init(frame: .zero)
        applyStyle()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    /// Child class can override this function to provide style
    public func applyStyle() {
        textColor = theme.colors.textPrimary
        numberOfLines = 0
    }
} 
