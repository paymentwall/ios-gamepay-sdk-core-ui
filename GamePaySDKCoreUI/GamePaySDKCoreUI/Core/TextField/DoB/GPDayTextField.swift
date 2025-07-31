//
//  GPDayTextField.swift
//  GamePaySDKCoreUI
//
//  Created by Luke Nguyen on 31/7/25.
//


struct DayFormatter: TextFieldFormatter {
    var maxLength: Int { 2 }
}

public class GPDayTextField: GPFormTextField {
    public init(theme: GPTheme) {
        super.init(
            title: "Day",
            placeholder: "Day",
            formatter: DayFormatter(),
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
