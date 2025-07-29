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
    private lazy var phoneCodeView: UIStackView = {
        let stv = UIStackView(arrangedSubviews: [flagLabel, codeLabel, icon])
        stv.alignment = .center
        stv.layer.borderColor = theme.colors.borderPrimary.cgColor
        stv.layer.borderWidth = theme.appearance.borderWidth
        stv.layer.cornerRadius = theme.appearance.cornerRadius
        stv.isLayoutMarginsRelativeArrangement = true
        stv.layoutMargins = UIEdgeInsets(
            top: 0,
            left: theme.appearance.padding,
            bottom: 0,
            right: theme.appearance.padding
        )
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapCountrySelector))
        stv.addGestureRecognizer(tap)
        
        return stv
    }()
    private lazy var flagLabel: UILabel = {
        let label = UILabel()
        label.font = theme.typography.body1
        label.setContentHuggingPriority(.required, for: .horizontal)
        return label
    }()
    private lazy var codeLabel: UILabel = {
        let label = UILabel()
        label.font = theme.typography.body1
        label.textColor = theme.colors.textPrimary
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        return label
    }()
    private lazy var icon: UIImageView = {
        let icon = UIImageView(image: GPAssets.icDropdown.image)
        icon.widthAnchor.constraint(equalToConstant: 24).isActive = true
        icon.heightAnchor.constraint(equalToConstant: 24).isActive = true
        return icon
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
        return [phoneCodeView, phoneTextField]
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
    
    // MARK: - Actions
    @objc private func didTapCountrySelector() {
        guard let vc = presentingViewController else { return }
        
        let sheet = GPDropdownSheetViewController<GPPhoneDropdownCell>(
            options: allCountries,
            selectedOption: selectedOption,
            navBarTitle: "Select country",
            hasSearchOption: true,
            theme: theme
        )
        
        sheet.onSelect = { [weak self] selectedCountry in
            guard let self, let selected = selectedCountry as? GPPhoneDropdownOption else { return }
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
            phoneTextField.placeholder = example
        }
        if let code = phoneNumberKit.countryCode(for: regionCode) {
            codeLabel.text = "+\(code)"
        }
        
        UIView.transition(with: phoneTextField, duration: 0.25, options: .transitionCrossDissolve, animations: {
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
