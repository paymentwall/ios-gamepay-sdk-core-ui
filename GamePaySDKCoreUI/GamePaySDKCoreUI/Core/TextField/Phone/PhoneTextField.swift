//
//  PhoneTextField.swift
//  GamePaySDKCoreUI
//
//  Created by Luke Nguyen on 25/7/25.
//

import UIKit

public class PhoneTextField: PayAltoFormTextField {
    // MARK: - Properties
    private let phoneNumberKit = PhoneNumberKit()
    private var selectedRegion: String
    private lazy var formatter = PartialFormatter(phoneNumberKit: phoneNumberKit, defaultRegion: selectedRegion)
    
    weak var presentingViewController: UIViewController?
    
    private let flagLabel = UILabel()
    private let codeLabel = UILabel()
    private let tapView = UIView()
    
    private var selectedOption: DropdownOption?
    
    private lazy var allCountries: [DropdownPhoneOption] = {
        phoneNumberKit.allCountries()
            .compactMap { DropdownPhoneOption(for: $0, with: phoneNumberKit) }
            .sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
    }()
    
    // MARK: - Overrides
    public override var formValue: String {
        return unformat(text)
    }
    
    public override var validationText: String {
        return unformat(text)
    }
    
    // MARK: - Init
    public init(formKey: String? = nil,
                defaultCountry: String? = nil,
                title: String,
                placeholder: String,
                presentingVC: UIViewController,
                theme: Theme) {
        self.selectedRegion = defaultCountry ?? "US" // Set default to US
        self.presentingViewController = presentingVC
        super.init(formKey: formKey, title: title, placeholder: placeholder, theme: theme)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    public override func setupView() {
        textField.keyboardType = .phonePad
        
        setupLabels()
        setupTapView()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapCountrySelector))
        tapView.addGestureRecognizer(tap)
        
        textField.leftView = tapView
        textField.leftViewMode = .always
        
        updateCountryUI(to: selectedRegion)
    }
    
    private func setupLabels() {
        flagLabel.font = defaultFont
        codeLabel.font = defaultFont
        codeLabel.textColor = theme.colors.textPrimary
        
        flagLabel.setContentHuggingPriority(.required, for: .horizontal)
        codeLabel.setContentHuggingPriority(.required, for: .horizontal)
        codeLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
    }
    
    private func setupTapView() {
        let stack = UIStackView(arrangedSubviews: [flagLabel, codeLabel])
        stack.axis = .horizontal
        stack.spacing = 2
        stack.alignment = .center
        
        tapView.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stack.centerYAnchor.constraint(equalTo: tapView.centerYAnchor),
            // TODO: Update padding
            stack.leadingAnchor.constraint(equalTo: tapView.leadingAnchor, constant: 16 / 2),
            stack.trailingAnchor.constraint(equalTo: tapView.trailingAnchor, constant: -16 / 2),
            stack.topAnchor.constraint(equalTo: tapView.topAnchor),
            stack.bottomAnchor.constraint(equalTo: tapView.bottomAnchor),
            stack.widthAnchor.constraint(lessThanOrEqualToConstant: 70),
            tapView.heightAnchor.constraint(equalToConstant: height),
        ])
    }
    
    // MARK: - Actions
    
    override func textDidChange() {
        guard let raw = textField.text else { return }
        
        let formatted = formatter.formatPartial(raw)
        if formatted != raw {
            textField.text = formatted
        }
        
        onTextChanged?(formatted)
    }
    
    @objc private func didTapCountrySelector() {
        guard let vc = presentingViewController else { return }
        
        let sheet = DropdownSheetViewController(
            options: allCountries,
            selectedOption: selectedOption,
            navBarTitle: "Select country",
            theme: theme
        )
        
        sheet.onSelect = { [weak self] selectedCountry in
            guard let self, let selected = selectedCountry as? DropdownPhoneOption else { return }
            self.selectedOption = selectedCountry
            self.updateCountryUI(to: selected.value)
        }
        
        vc.presentAsBottomSheet(sheet, theme: theme)
    }
    
    // MARK: - Helpers
    
    private func updateCountryUI(to regionCode: String) {
        selectedRegion = regionCode
        formatter = PartialFormatter(phoneNumberKit: phoneNumberKit, defaultRegion: regionCode)
        
        if let example = phoneNumberKit.getFormattedExampleNumber(forCountry: regionCode, withPrefix: false) {
            placeholder = example
        }
        
        flagLabel.text = regionCode.getFlagScalar()
        
        if let code = phoneNumberKit.countryCode(for: regionCode) {
            codeLabel.text = "+\(code)"
        }
    }
    
    private func unformat(_ text: String?) -> String {
        guard let text else { return "" }
        
        do {
            let parsedNumber = try phoneNumberKit.parse(text, withRegion: selectedRegion)
            return String(parsedNumber.nationalNumber)
        } catch {
            return text.filter(\.isWholeNumber)
        }
    }
}
