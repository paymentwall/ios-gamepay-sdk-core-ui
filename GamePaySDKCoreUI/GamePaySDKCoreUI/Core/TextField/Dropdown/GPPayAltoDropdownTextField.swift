//
//  GPPayAltoDropdownTextField.swift
//  GamePaySDKCoreUI
//
//  Created by Luke Nguyen on 28/7/25.
//

import UIKit

public class GPPayAltoDropdownTextField: GPDropdownTextField<GPIconTextDropdownCell>, FormElement {
    public var view: UIView { self }
    public var formKey: String?
    public var formValue: String {
        return selectedValue
    }
    
    public init(
        formKey: String,
        options: [GPDropdownOption],
        title: String,
        placeholder: String,
        hasSearchOption: Bool = false,
        presentingVC: UIViewController,
        theme: GPTheme,
        onSelect: ((GPDropdownOption) -> Void)? = nil
    ) {
        self.formKey = formKey
        super.init(
            options: options,
            title: title,
            placeholder: placeholder,
            hasSearchOption: hasSearchOption,
            presentingVC: presentingVC,
            theme: theme,
            onSelect: onSelect
        )
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
