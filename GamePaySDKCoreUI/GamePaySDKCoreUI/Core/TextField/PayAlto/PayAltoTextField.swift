//
//  PayAltoTextField.swift
//  GamePaySDKCoreUI
//
//  Created by Luke Nguyen on 24/7/25.
//

import UIKit

public class PayAltoTextField: FormTextField, FormElement {
    // MARK: - FormElement
    public var view: UIView { self }
    public var formKey: String?
    public var formValue: String { text }
}
