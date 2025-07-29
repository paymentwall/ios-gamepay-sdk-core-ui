//
//  PhoneTextField.swift
//  GamePaySDKCoreUI
//
//  Created by Luke Nguyen on 25/7/25.
//

import UIKit

public class PhoneTextField: FormTextField {
    // MARK: - Properties
    private let phoneNumberKit = PhoneNumberKit()
    private var selectedRegion: String
    private lazy var formatter = PartialFormatter(phoneNumberKit: phoneNumberKit, defaultRegion: selectedRegion)
    
    weak var presentingViewController: UIViewController?
    private var selectedOption: DropdownOption?
    private lazy var allCountries: [PhoneDropdownOption] = {
        phoneNumberKit.allCountries()
            .compactMap { PhoneDropdownOption(for: $0, with: phoneNumberKit) }
            .sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
    }()
    
    // MARK: - UI Properties
    private var phoneCodeStackView = UIStackView()
    private let flagLabel = UILabel()
    private let codeLabel = UILabel()
    private let icon = UIImageView(image: GPAssets.icDropdown.image)
    
    // MARK: - Overrides
    public override var validationText: String {
        return unformat(text)
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
        textField.keyboardType = .phonePad
        
        phoneCodeStackView = UIStackView(arrangedSubviews: [flagLabel, codeLabel, icon])
        icon.widthAnchor.constraint(equalToConstant: 24).isActive = true
        icon.heightAnchor.constraint(equalToConstant: 24).isActive = true
        phoneCodeStackView.alignment = .center
        phoneCodeStackView.layer.borderColor = theme.colors.borderPrimary.cgColor
        phoneCodeStackView.layer.borderWidth = theme.appearance.borderWidth
        phoneCodeStackView.layer.cornerRadius = theme.appearance.cornerRadius
        phoneCodeStackView.isLayoutMarginsRelativeArrangement = true
        phoneCodeStackView.layoutMargins = UIEdgeInsets(
            top: 0,
            left: theme.appearance.padding,
            bottom: 0,
            right: theme.appearance.padding
        )

        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapCountrySelector))
        phoneCodeStackView.addGestureRecognizer(tap)
        flagLabel.font = theme.typography.body1
        codeLabel.font = theme.typography.body1
        codeLabel.textColor = theme.colors.textPrimary
        flagLabel.setContentHuggingPriority(.required, for: .horizontal)
        codeLabel.setContentHuggingPriority(.required, for: .horizontal)
        codeLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        tfStackView.removeAllSubviews()
        [phoneCodeStackView, textField].forEach {
            tfStackView.addArrangedSubview($0)
        }
        
        updateCountryUI(to: selectedRegion)
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
        
        let sheet = DropdownSheetViewController<PhoneDropdownCell>(
            options: allCountries,
            selectedOption: selectedOption,
            navBarTitle: "Select country",
            hasSearchOption: true,
            theme: theme
        )
        
        sheet.onSelect = { [weak self] selectedCountry in
            guard let self, let selected = selectedCountry as? PhoneDropdownOption else { return }
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
        if let code = phoneNumberKit.countryCode(for: regionCode) {
            codeLabel.text = "+\(code)"
        }
        
        UIView.transition(with: textField, duration: 0.25, options: .transitionCrossDissolve, animations: {
            self.flagLabel.text = regionCode.getFlagScalar()
        }, completion: nil)
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
