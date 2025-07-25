//
//  PhoneOptionView.swift
//  GamePaySDKCoreUI
//
//  Created by Luke Nguyen on 25/7/25.
//


import UIKit

class PhoneOptionView: DropdownOptionView {
    private let flagLabel = UILabel()
    private let codeLabel = UILabel()
    private let titleLabel = UILabel()
    
    override func setupView() {
        flagLabel.translatesAutoresizingMaskIntoConstraints = false
        codeLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
    }

    func configure(with option: DropdownPhoneOption, delegate: DropdownOptionViewDelegate?) {
        self.option = option
        self.delegate = delegate
        flagLabel.text = option.flag
        codeLabel.text = option.phoneCode.map { "+\($0)" }
        titleLabel.text = option.name
        configureSubviews([flagLabel, codeLabel, titleLabel])
    }
}

