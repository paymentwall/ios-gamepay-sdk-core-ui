//
//  PayAltoDropdownTextField.swift
//  GamePaySDKCoreUI
//
//  Created by Luke Nguyen on 28/7/25.
//

import UIKit

public class PayAltoDropdownTextField: DropdownTextField, FormElement {
    public var view: UIView { self }
    public var formKey: String?
    public var formValue: String {
        return selectedValue
    }
    
    public init(
        formKey: String,
        options: [DropdownOption],
        title: String,
        placeholder: String,
        presentingVC: UIViewController,
        theme: GPTheme
    ) {
        self.formKey = formKey
        super.init(
            options: options,
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
