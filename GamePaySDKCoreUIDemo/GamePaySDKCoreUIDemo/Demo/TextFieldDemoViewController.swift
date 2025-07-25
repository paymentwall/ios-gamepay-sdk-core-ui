//
//  TextFieldDemoViewController.swift
//  GamePaySDKCoreUIDemo
//
//  Created by henry on 7/25/25.
//


import UIKit
import GamePaySDKCoreUI

class TextFieldDemoViewController: UIViewController, FormViewValidatable {
    
    let validator = Validator()
    var allValidatableFields: [ErrorMessageProvider] = []
    
    // MARK: - UI Elements
    @IBOutlet weak var stvContainer: UIStackView!
    lazy var demoButton: UIView = {
        let btn = GPPrimaryButton(theme: theme)
//        btn.setTitle("Demo button", for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
//        btn.addTarget(self, action: #selector(validateAndSubmit), for: .touchUpInside)
        return btn
    }()
    
    lazy var emailField: FormTextField = {
        let tf = FormTextField(title: "Your email", placeholder: "Enter your email", theme: theme)
        return tf
    }()
    
    private lazy var panField = PANTextField(theme: theme)
    private lazy var expDateField = ExpDateTextField(theme: theme)
    private lazy var cvvField = CVVTextField(theme: theme)
    private lazy var dropdownTextField = DropdownTextField(
        formKey: "form-key",
        options: [.init(
            value: "apple",
            name: "Apple",
            logoUrl: "https://yt3.googleusercontent.com/F6YRXcBbkvTCIDvHrXqWfnht_stmrhSRvVVtTybO4JyBXFeyAOjMIWM-PlOq_8UTaPSGtXAyMA=s900-c-k-c0x00ffffff-no-rj"
        ), .init(value: "google", name: "Google", logoUrl: "https://yt3.googleusercontent.com/2eI1TjX447QZFDe6R32K0V2mjbVMKT5mIfQR-wK5bAsxttS_7qzUDS1ojoSKeSP0NuWd6sl7qQ=s900-c-k-c0x00ffffff-no-rj")],
        title: "Dropdown Textfield",
        placeholder: "Choose an option",
        presentingVC: self,
        theme: theme
    )
    private lazy var phoneTextField = PhoneTextField(
        formKey: "phone_form_key",
        defaultCountry: "VN",
        title: "Phone number",
        placeholder: "Enter phone number",
        presentingVC: self,
        theme: theme
    )
    
    // MARK: - Properties
    private let theme = GPThemeStore.defaultTheme
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTapEndEditing()
        
        [emailField, panField, expDateField, cvvField, dropdownTextField, phoneTextField].forEach {
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

extension TextFieldDemoViewController: ValidationDelegate {
    func validationSuccessful() {
        hideValidationErrors()
        view.endEditing(true)
    }
    
    func validationFailed(_ errors: [(any Validatable, ValidationError)]) {
        showValidationErrors(errors)
    }
}

