//
//  GPCVVTextField.swift
//  GamePaySDKCoreUI
//
//  Created by Luke Nguyen on 24/7/25.
//

import Foundation

struct CVVFormatter: TextFieldFormatter {
    var maxLength: Int { 4 }
}

public class GPCVVTextField: GPFormTextField {
    public init(theme: GPTheme) {
        super.init(
            title: "CVV",
            placeholder: "CVV",
            formatter: CVVFormatter(),
            theme: theme
        )
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        textField.keyboardType = .numberPad
        setIcon(GPCoreUIAssets.icCVV.image, on: .Right, useTemplate: false)
    }
}
