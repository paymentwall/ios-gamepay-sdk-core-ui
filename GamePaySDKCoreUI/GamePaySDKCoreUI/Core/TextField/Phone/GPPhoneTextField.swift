//
//  GPPhoneTextField.swift
//  GamePaySDKCoreUI
//
//  Created by Luke Nguyen on 25/7/25.
//

import UIKit

public class GPPhoneTextField: GPBaseTextField {
    // MARK: - Properties
    private let phoneNumberKit = PhoneNumberKit()
    private var selectedRegion: String
    private lazy var formatter = PartialFormatter(phoneNumberKit: phoneNumberKit, defaultRegion: selectedRegion)
    
    weak var presentingViewController: UIViewController?
    private var selectedOption: GPDropdownOption?
    private lazy var allCountries: [GPPhoneDropdownOption] = {
        phoneNumberKit.allCountries()
            .compactMap { GPPhoneDropdownOption(for: $0, with: phoneNumberKit) }
            .sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
    }()
    
    // MARK: - UI Properties
    private lazy var phoneDropdown: GPDropdownTextField<GPPhoneDropdownCell> = {
        /// HACK: The `placeholder` cause the width constraint which breaks layout
        /// For phone dropdown, no need placeholder as set default phone country code
        let dropdown = GPDropdownTextField<GPPhoneDropdownCell>(
            options: allCountries,
            title: "Select country",
            placeholder: "",
            hasSearchOption: true,
            presentingVC: presentingViewController ?? UIViewController(),
            theme: theme
        ) { [weak self] selectedCountry in
            guard let self, let selectedCountry = selectedCountry as? GPPhoneDropdownOption else { return }
            updateCountryUI(to: selectedCountry.value)
        }
        dropdown.setPlainTextField()
        
        return dropdown
    }()
    
    private lazy var flagLabel: UILabel = {
        let label = UILabel()
        label.font = theme.typography.body1
        label.setContentHuggingPriority(.required, for: .horizontal)
        return label
    }()
    
    lazy var phoneTextField: GPFormTextField = {
        let field = GPFormTextField(title: "", placeholder: "", theme: theme)
        field.textField.keyboardType = .phonePad
        field.setPlainTextField()
        return field
    }()
    
    // MARK: - Overrides
    public override var validationText: String {
        return unformat(phoneTextField.text)
    }
    
    public override func getChildViews() -> [UIView] {
        return [phoneDropdown, phoneTextField]
    }
    
    // MARK: - Init
    public init(defaultCountry: String? = nil,
                title: String,
                placeholder: String,
                presentingVC: UIViewController,
                theme: GPTheme) {
        self.selectedRegion = defaultCountry ?? "US" // Set default to US
        self.presentingViewController = presentingVC
        super.init(title: title, placeholder: placeholder, theme: theme)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    private func setupView() {
        phoneTextField.onTextChanged = { [weak self] raw in
            guard let self else { return }
            let formatted = formatter.formatPartial(raw)
            if formatted != raw {
                phoneTextField.setText(formatted)
            }
        }
        
        updateCountryUI(to: selectedRegion)
    }
    
    // MARK: - Helpers
    private func updateCountryUI(to regionCode: String) {
        selectedRegion = regionCode
        formatter = PartialFormatter(phoneNumberKit: phoneNumberKit, defaultRegion: regionCode)

        if let example = phoneNumberKit.getFormattedExampleNumber(forCountry: regionCode, withPrefix: false) {
            phoneTextField.placeholder = example
        }
        if let code = phoneNumberKit.countryCode(for: regionCode) {
            let phoneCode = "+\(code)"
            phoneDropdown.setText(phoneCode)
        }
        
        flagLabel.text = regionCode.getFlagScalar()
        phoneDropdown.applyIconView(flagLabel, on: .Left, animated: true)
    }
    
    func unformat(_ text: String?) -> String {
        guard let text else { return "" }
        
        do {
            let parsedNumber = try phoneNumberKit.parse(text, withRegion: selectedRegion)
            return String(parsedNumber.nationalNumber)
        } catch {
            return text.filter(\.isWholeNumber)
        }
    }
}
