//
//  PayAltoPhoneTextField.swift
//  GamePaySDKCoreUI
//
//  Created by Luke Nguyen on 28/7/25.
//

import UIKit

public class PayAltoPhoneTextField: PhoneTextField, FormElement {
    public var view: UIView { self }
    public var formKey: String?
    public var formValue: String {
        return unformat(text)
    }
    
    public init(formKey: String,
                defaultCountry: String? = nil,
                title: String,
                placeholder: String,
                presentingVC: UIViewController,
                theme: GPTheme) {
        self.formKey = formKey
        super.init(
            defaultCountry: defaultCountry,
            title: title,
            placeholder: placeholder,
            presentingVC: presentingVC,
            theme: theme
        )
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
