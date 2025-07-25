//
//  PayAltoFormTextField.swift
//  GamePaySDKCoreUI
//
//  Created by Luke Nguyen on 24/7/25.
//

import UIKit

public class PayAltoFormTextField: FormTextField, FormElement {
    // MARK: - FormElement
    public var view: UIView { self }
    public var formKey: String?
    public var formValue: String { text }
    
    public init(
        formKey: String? = nil,
        title: String,
        placeholder: String,
        theme: GPTheme
    ) {
        self.formKey = formKey
        super.init(title: title, placeholder: placeholder, theme: theme)
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
