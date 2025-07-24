//
//  CVVTextField.swift
//  GamePaySDKCoreUI
//
//  Created by Luke Nguyen on 24/7/25.
//

struct CVVFormatter: TextFieldFormatter {
    var maxLength: Int { 4 }
}

public class CVVTextField: FormTextField {
    public init(theme: Theme) {
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
        setIcon(GPAssets.icCVV.image, .Right, withTemplate: false)
    }
}
