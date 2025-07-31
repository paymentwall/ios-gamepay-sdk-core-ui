//
//  GPDoBTextField.swift
//  GamePaySDKCoreUI
//
//  Created by Luke Nguyen on 30/7/25.
//

import UIKit

public class GPDoBTextField: GPBaseTextField {
    
    // MARK: - Constants
    
    private let monthsMap: [String: String] = [
        "January": "01", "February": "02", "March": "03",
        "April": "04", "May": "05", "June": "06",
        "July": "07", "August": "08", "September": "09",
        "October": "10", "November": "11", "December": "12"
    ]
    
    private let fieldWidth: CGFloat = 80
    private let dateFormat: String
    private weak var presentingViewController: UIViewController?
    private var selectedMonth: String?
    
    // MARK: - Computed Properties
    
    private var monthOptions: [GPDropdownOption] {
        monthsMap
            .sorted { $0.value < $1.value }
            .map { GPDropdownOption(value: $1, name: $0) }
    }
    
    public override var validationText: String {
        return formattedDOB()
    }
    
    // MARK: - Subviews
    
    private lazy var dayTextField: GPFormTextField = {
        let tf = GPDayTextField(theme: theme)
        tf.setPlainTextField()
        tf.widthAnchor.constraint(equalToConstant: fieldWidth).isActive = true
        return tf
    }()
    
    private lazy var monthTextField: GPDropdownTextField<GPIconTextDropdownCell> = {
        let tf = GPDropdownTextField<GPIconTextDropdownCell>(
            options: monthOptions,
            title: "",
            dropdownTitle: "Select month",
            placeholder: "Month",
            presentingVC: presentingViewController ?? UIViewController(),
            theme: theme
        ) { [weak self] option in
            self?.selectedMonth = option.value
        }
        tf.setPlainTextField()
        return tf
    }()
    
    private lazy var yearTextField: GPFormTextField = {
        let tf = GPYearTextField(theme: theme)
        tf.setPlainTextField()
        tf.widthAnchor.constraint(equalToConstant: fieldWidth).isActive = true
        return tf
    }()
    
    // MARK: - Initializers
    
    public init(dateFormat: String, presentingVC: UIViewController, theme: GPTheme) {
        self.dateFormat = dateFormat
        self.presentingViewController = presentingVC
        super.init(title: "Date of Birth", placeholder: "", theme: theme)
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Layout
    
    public override func getChildViews() -> [UIView] {
        return [dayTextField, monthTextField, yearTextField]
    }
    
    // MARK: - Helpers
    private func formattedDOB() -> String {
        let rawYear = yearTextField.text
        let rawMonth = selectedMonth ?? ""
        let rawDay = dayTextField.text
        
        return dateFormat
            .replacingOccurrences(of: "yyyy", with: rawYear)
            .replacingOccurrences(of: "MM", with: rawMonth)
            .replacingOccurrences(of: "dd", with: rawDay)
    }
}
