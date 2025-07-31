//
//  FormViewValidatable.swift
//  GamePaySDK
//
//  Created by Luke Nguyen on 12/6/25.
//

import UIKit

public typealias FormElementType = AnyObject & Validatable & ErrorMessageProvider

/// Protocol of Pay Alto `FormElement`
/// - Parameters:
///   - view: The main element view
///   - formKey: The submit form key of element
///   - formValue: The submit form value of element
public protocol FormElement: FormElementType {
    var view: UIView { get }
    var formKey: String? { get }
    var formValue: String { get }
}

public protocol FormViewValidatable {
    var validator: Validator { get }
    var allValidatableFields: [ErrorMessageProvider] { get }
}

public protocol ErrorMessageProvider {
    func showError(message: String?)
    func hideError()
}

public extension FormViewValidatable where Self: UIViewController {
    
    func showValidationErrors(_ errors: [(Validatable, ValidationError)], animated: Bool = true) {
        let animationBlock = {
            self.hideValidationErrors(animated: false)
            for (field, error) in errors {
                if let textField = field as? ErrorMessageProvider {
                    textField.showError(message: error.errorMessage)
                }
            }
            self.view.layoutIfNeeded()
        }
        if animated {
            UIView.animate(withDuration: 0.25) {
                animationBlock()
            }
        } else {
            animationBlock()
        }
    }
    
    func hideValidationErrors(animated: Bool = true) {
        let animationBlock = {
            for textField in self.allValidatableFields {
                textField.hideError()
            }
            self.view.layoutIfNeeded()
        }
        if animated {
            UIView.animate(withDuration: 0.25) {
                animationBlock()
            }
        } else {
            animationBlock()
        }
    }
}

public extension FormViewValidatable where Self: UIView {
    
    func showValidationErrors(_ errors: [(Validatable, ValidationError)], animated: Bool = true) {
        let animationBlock = {
            self.hideValidationErrors(animated: false)
            for (field, error) in errors {
                if let textField = field as? ErrorMessageProvider {
                    textField.showError(message: error.errorMessage)
                }
            }
            self.layoutIfNeeded()
        }
        if animated {
            UIView.animate(withDuration: 0.25) {
                animationBlock()
            }
        } else {
            animationBlock()
        }
    }
    
    func hideValidationErrors(animated: Bool = true) {
        let animationBlock = {
            for textField in self.allValidatableFields {
                textField.hideError()
            }
            self.layoutIfNeeded()
        }
        if animated {
            UIView.animate(withDuration: 0.25) {
                animationBlock()
            }
        } else {
            animationBlock()
        }
    }
}
