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
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func setupView() {
        textField.keyboardType = .numberPad
        setIcon(GPAssets.icCVV.image, on: .Right, useTemplate: false)
    }
}
