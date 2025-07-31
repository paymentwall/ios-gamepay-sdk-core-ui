//
//  GPYearTextField.swift
//  GamePaySDKCoreUI
//
//  Created by Luke Nguyen on 31/7/25.
//


struct YearFormatter: TextFieldFormatter {
    var maxLength: Int { 4 }
}

public class GPYearTextField: GPFormTextField {
    public init(theme: GPTheme) {
        super.init(
            title: "Year",
            placeholder: "Year",
            formatter: YearFormatter(),
            theme: theme
        )
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        textField.keyboardType = .numberPad
    }
}
