//
//  SearchTextField.swift
//  GamePaySDKCoreUI
//
//  Created by Luke Nguyen on 28/7/25.
//

import UIKit

public class SearchTextField: FormTextField {
    private let clearButton = UIButton(type: .system)
    
    public init(theme: GPTheme, onTextChange: @escaping (String) -> Void) {
        super.init(title: "", placeholder: "Search", theme: theme)
        self.onTextChanged = onTextChange
        setupView()
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        titleLabel.isHidden = true
        errorView.isHidden = true
        
        setIcon(GPAssets.icSearch.image, on: .Left)
        
        clearButton.setImage(GPAssets.icCloseNavBar.image, for: .normal)
        clearButton.tintColor = theme.colors.borderPrimary
        clearButton.isHidden = true
        clearButton.addTarget(self, action: #selector(clearTapped), for: .touchUpInside)
        applyIconView(clearButton, on: .Right, animated: true)
    }
    
    @objc private func clearTapped() {
        textField.text = ""
        updateClearButtonVisibility()
        onTextChanged?("")
    }
    
    override func textDidChange() {
        updateClearButtonVisibility()
        super.textDidChange()
    }
    
    private func updateClearButtonVisibility(animated: Bool = true) {
        let shouldShow = !(textField.text ?? "").isEmpty
        
        guard clearButton.isHidden != !shouldShow else { return }
        
        if animated {
            UIView.performWithoutAnimation {
                UIView.transition(with: clearButton, duration: 0.25, options: .transitionCrossDissolve) {
                    self.clearButton.isHidden = !shouldShow
                    self.tfStackView.layoutIfNeeded() // Ensure smooth layout change
                }
            }
        } else {
            clearButton.isHidden = !shouldShow
        }
    }
}
