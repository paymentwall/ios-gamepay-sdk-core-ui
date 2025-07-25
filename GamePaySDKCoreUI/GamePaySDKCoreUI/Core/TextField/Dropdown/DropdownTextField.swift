//
//  DropdownTextField.swift
//  GamePaySDKCoreUI
//
//  Created by Luke Nguyen on 25/7/25.
//

import UIKit

public class DropdownTextField: PayAltoFormTextField {
    public override var formValue: String {
        return selectedValue
    }
    
    private var selectedOption: DropdownOption?
    private var selectedValue: String {
        selectedOption?.value ?? ""
    }
    
    let options: [DropdownOption]
    weak var presentingViewController: UIViewController?
    
    private let dropdownIcon = GPAssets.icDropdown.image
  
    public init(
        formKey: String? = nil,
        options: [DropdownOption],
        title: String,
        placeholder: String,
        presentingVC: UIViewController,
        theme: Theme
    ) {
        self.options = options
        self.presentingViewController = presentingVC
        super.init(formKey: formKey, title: title, placeholder: placeholder, theme: theme)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func setupView() {
        textField.isUserInteractionEnabled = false
        setIcon(dropdownIcon, on: .Right, useTemplate: true)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapDropdown))
        addGestureRecognizer(tapGesture)
    }

    @objc private func didTapDropdown() {
        guard let vc = presentingViewController else { return }
        let sheet = DropdownSheetViewController(
            options: options,
            selectedOption: selectedOption,
            navBarTitle: placeholder,
            theme: theme
        )
        sheet.onSelect = { [weak self] selected in
            self?.selectedOption = selected
            if let logoUrl = self?.selectedOption?.logoUrl {
                self?.setIcon(from: logoUrl, on: .Left, animated: true)
            }
            self?.setText(selected.name)
        }
        vc.presentAsBottomSheet(sheet, theme: theme)
    }
}
