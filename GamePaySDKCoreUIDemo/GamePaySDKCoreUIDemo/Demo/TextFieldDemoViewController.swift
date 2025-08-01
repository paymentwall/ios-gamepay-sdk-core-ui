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
    private lazy var allTextFields: [GPBaseTextField] = [searchTextField, phoneTextField, emailField, panField, expDateField, cvvField, dropdownTextField]
    
    lazy var demoButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Validate", for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(validateAndSubmit), for: .touchUpInside)
        return btn
    }()
    
    lazy var emailField: GPFormTextField = {
        let tf = GPFormTextField(title: "Your email", placeholder: "Enter your email", theme: theme)
        return tf
    }()
    
    private lazy var panField = GPPanTextField(theme: theme)
    private lazy var expDateField = GPExpDateTextField(theme: theme)
    private lazy var cvvField = GPCVVTextField(theme: theme)
    private lazy var dropdownTextField = GPDropdownTextField<GPIconTextDropdownCell>(options: [.init(
            value: "apple",
            name: "Apple",
            logoUrl: "https://yt3.googleusercontent.com/F6YRXcBbkvTCIDvHrXqWfnht_stmrhSRvVVtTybO4JyBXFeyAOjMIWM-PlOq_8UTaPSGtXAyMA=s900-c-k-c0x00ffffff-no-rj"
        ), .init(value: "google", name: "Google", logoUrl: "https://yt3.googleusercontent.com/2eI1TjX447QZFDe6R32K0V2mjbVMKT5mIfQR-wK5bAsxttS_7qzUDS1ojoSKeSP0NuWd6sl7qQ=s900-c-k-c0x00ffffff-no-rj")],
        title: "Dropdown",
        placeholder: "Choose an option",
        presentingVC: self,
        theme: theme
    )
    private lazy var phoneTextField = GPPayAltoPhoneTextField(
        formKey: "phone_form_key",
        defaultCountry: "VN",
        title: "Phone number",
        placeholder: "Enter phone number",
        presentingVC: self,
        theme: theme
    )
    private lazy var searchTextField: GPSearchTextField = {
        let search = GPSearchTextField(theme: theme) { [weak self] text in
            print(text)
        }
        
        return search
    }()
    
    // MARK: - Properties
    private let theme = GPThemeStore.defaultTheme
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTapEndEditing()
        
        allTextFields.forEach {
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
        
        validator.registerField(dropdownTextField, rules: [RequiredRule()])
        validator.registerField(phoneTextField, rules: [RequiredRule()])
    }

    @objc
    private func validateAndSubmit() {
        for allTextField in allTextFields {
            print(allTextField.validationText)
        }
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

