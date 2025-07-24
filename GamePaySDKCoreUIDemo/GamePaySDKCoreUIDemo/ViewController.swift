//
//  ViewController.swift
//  GamePaySDKCoreUIDemo
//
//  Created by henry on 7/23/25.
//

import UIKit
import GamePaySDKCoreUI

class ViewController: UIViewController, FormViewValidatable {
    
    let validator = Validator()
    var allValidatableFields: [ErrorMessageProvider] = []
    
    // MARK: - UI Elements
    @IBOutlet weak var stvContainer: UIStackView!
    lazy var demoButton: UIButton = {
        let btn = DemoButton(theme: theme)
        btn.setTitle("Demo button", for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(validateAndSubmit), for: .touchUpInside)
        return btn
    }()
    
    lazy var emailField: FormTextField = {
        let tf = FormTextField(title: "Your email", placeholder: "Enter your email", theme: theme)
        return tf
    }()
    
    private lazy var panField = PANTextField(theme: theme)
    private lazy var expDateField = ExpDateTextField(theme: theme)
    private lazy var cvvField = CVVTextField(theme: theme)
    
    // MARK: - Properties
    private let theme = ThemeStore.defaultTheme
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTapEndEditing()
        
        [emailField, panField, expDateField, cvvField].forEach {
            stvContainer.addArrangedSubview($0)
        }
        stvContainer.addArrangedSubview(demoButton)
        
        setupRules()
    }
    
    private func setupRules() {
        validator.registerField(emailField, rules: [
            RequiredRule(message: AppMessage.Validation.EmailEmpty),
            EmailRule()
        ])
        
        validator.registerField(panField, rules: [
            RequiredRule(message: AppMessage.Validation.CardNumberEmpty),
            CustomCardNumberRule()
        ])
        
        validator.registerField(expDateField, rules: [
            RequiredRule(message: AppMessage.Validation.ExpityDateEmpty),
            CardExpiredDateRule()
        ])
        
        validator.registerField(cvvField, rules: [
            RequiredRule(message: AppMessage.Validation.CVVEmpty),
            CVVRule()
        ])
    }

    @objc
    private func validateAndSubmit() {
        validator.validate(self)
    }
    
    func setupTapEndEditing() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tap)
    }
    
    @objc private func dismissKeyboard(){
        self.view.endEditing(true)
    }
}

extension ViewController: ValidationDelegate {
    func validationSuccessful() {
        hideValidationErrors()
        view.endEditing(true)
    }
    
    func validationFailed(_ errors: [(any Validatable, ValidationError)]) {
        showValidationErrors(errors)
    }
}

