//
//  UIStackView+.swift
//  GamePaySDKCoreUI
//
//  Created by Luke Nguyen on 25/7/25.
//

import UIKit

extension UIStackView {
    public func removeAllSubviews() {
        self.arrangedSubviews.forEach { subView in
            self.removeArrangedSubview(subView)
            subView.removeFromSuperview()
        }
    }
    
    func setupVerticalStackView() {
        axis = .vertical
        spacing = GPThemeStore.defaultTheme.appearance.rowSpacing
        translatesAutoresizingMaskIntoConstraints = false
    }
}
