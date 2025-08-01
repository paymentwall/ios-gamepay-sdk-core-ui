//
//  GPExpDateTextField.swift
//  GamePaySDKCoreUI
//
//  Created by Luke Nguyen on 24/7/25.
//

import Foundation

struct ExpDateFormatter: TextFieldFormatter {
    var maxLength: Int { 5 } // MM/YY

    func format(_ text: String) -> String {
        let digits = text.filter(\.isNumber)
        guard !digits.isEmpty else { return "" }

        let month = digits.prefix(2)
        let year = digits.dropFirst(2)

        var result = String(month)
        if !year.isEmpty {
            result += "/" + year.prefix(2)
        }
        return result
    }
}

public class GPExpDateTextField: GPFormTextField {
    private let prefixYear = "20"
    
    public var expMonth: String {
        String(validationText.prefix(2))
    }
    
    public var expYear: String {
        String(validationText.suffix(2))
    }
    
    public init(theme: GPTheme) {
        super.init(
            title: "Exp. Date",
            placeholder: "MM / YY",
            formatter: ExpDateFormatter(),
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
