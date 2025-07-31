//
//  GPDropdownTextField.swift
//  GamePaySDKCoreUI
//
//  Created by Luke Nguyen on 25/7/25.
//

import UIKit

public class GPDropdownTextField<T: GPBaseDropdownCell>: GPFormTextField {
    
    // MARK: - Properties
    public var selectedValue: String {
        selectedOption?.value ?? ""
    }
    
    private let options: [GPDropdownOption]
    private weak var presentingViewController: UIViewController?
    private var selectedOption: GPDropdownOption?
    private let dropdownIcon = GPAssets.icDropdown.image
    private let hasSearchOption: Bool
    private let onSelect: ((GPDropdownOption) -> Void)?
    
    // MARK: - Initializer
    public init(
        options: [GPDropdownOption],
        title: String,
        placeholder: String,
        hasSearchOption: Bool = false,
        presentingVC: UIViewController,
        theme: GPTheme,
        onSelect: ((GPDropdownOption) -> Void)? = nil
    ) {
        self.options = options
        self.hasSearchOption = hasSearchOption
        self.presentingViewController = presentingVC
        self.onSelect = onSelect
        super.init(title: title, placeholder: placeholder, theme: theme)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    private func setupView() {
        textField.isUserInteractionEnabled = false
        setIcon(dropdownIcon, on: .Right, useTemplate: true)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapDropdown))
        addGestureRecognizer(tapGesture)
    }
    
    // MARK: - Actions
    @objc private func didTapDropdown() {
        guard let viewController = presentingViewController else { return }
        
        let navBarTitle = placeholder.isEmpty ? title : placeholder
        
        let sheet = GPDropdownSheetViewController<T>(
            options: options,
            selectedOption: selectedOption,
            navBarTitle: navBarTitle,
            hasSearchOption: hasSearchOption,
            theme: theme
        )
        
        sheet.onSelect = { [weak self] selected in
            guard let self = self else { return }
            self.selectedOption = selected
            self.setText(selected.name)
            if let logoUrl = selected.logoUrl {
                self.setIcon(from: logoUrl, on: .Left, animated: true)
            }
            onSelect?(selected)
        }
        
        viewController.presentAsBottomSheet(sheet, theme: theme)
    }
}
