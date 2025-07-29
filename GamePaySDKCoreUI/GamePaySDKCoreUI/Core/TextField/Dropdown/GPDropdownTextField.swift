//
//  GPDropdownTextField.swift
//  GamePaySDKCoreUI
//
//  Created by Luke Nguyen on 25/7/25.
//

import UIKit

public class GPDropdownTextField: GPFormTextField {
    
    // MARK: - Properties
    public var selectedValue: String {
        selectedOption?.value ?? ""
    }
    
    private let options: [GPDropdownOption]
    private weak var presentingViewController: UIViewController?
    private var selectedOption: GPDropdownOption?
    private let dropdownIcon = GPAssets.icDropdown.image
    
    // MARK: - Initializer
    public init(
        options: [GPDropdownOption],
        title: String,
        placeholder: String,
        presentingVC: UIViewController,
        theme: GPTheme
    ) {
        self.options = options
        self.presentingViewController = presentingVC
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
        
        let sheet = GPDropdownSheetViewController<GPIconTextDropdownCell>(
            options: options,
            selectedOption: selectedOption,
            navBarTitle: placeholder,
            theme: theme
        )
        
        sheet.onSelect = { [weak self] selected in
            guard let self = self else { return }
            self.selectedOption = selected
            self.setText(selected.name)
            
            if let logoUrl = selected.logoUrl {
                self.setIcon(from: logoUrl, on: .Left, animated: true)
            }
        }
        
        viewController.presentAsBottomSheet(sheet, theme: theme)
    }
}
