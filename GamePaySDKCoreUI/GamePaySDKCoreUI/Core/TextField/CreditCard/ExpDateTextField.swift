//
//  ExpDateTextField.swift
//  GamePaySDKCoreUI
//
//  Created by Luke Nguyen on 24/7/25.
//

struct ExpDateFormatter: TextFieldFormatter {
    var maxLength: Int { 4 } // MMYY

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
    
    func unformatted(_ text: String) -> String {
        return text.replacingOccurrences(of: "/", with: "")
    }
}

public class ExpDateTextField: FormTextField {
    
    private let prefixYear = "20"
    
    public init(theme: GPTheme) {
        super.init(
            title: "Exp. Date",
            placeholder: "MM / YY",
            formatter: ExpDateFormatter(),
            theme: theme
        )
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override var validationText: String {
        return expDateFormatted
    }
    
    public override func setupView() {
        textField.keyboardType = .numberPad
    }

    var expDateFormatted: String {
        textField.text?.replacingOccurrences(of: "/", with: "") ?? ""
    }

    var expMonth: String {
        String(expDateFormatted.prefix(2))
    }

    var expYear: String {
        prefixYear + String(expDateFormatted.suffix(2))
    }
}
