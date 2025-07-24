//
//  PANTextField.swift
//  GamePaySDKCoreUI
//
//  Created by Luke Nguyen on 24/7/25.
//

import UIKit

struct PANFormatter: TextFieldFormatter {
    var maxLength: Int { 19 }

    func format(_ text: String) -> String {
        let digits = text.filter(\.isNumber)
        return stride(from: 0, to: digits.count, by: 4)
            .lazy
            .map { i in
                let start = digits.index(digits.startIndex, offsetBy: i)
                let end = digits.index(start, offsetBy: 4, limitedBy: digits.endIndex) ?? digits.endIndex
                return digits[start..<end]
            }
            .joined(separator: " ")
    }
    
    func unformatted(_ text: String) -> String {
        text.replacingOccurrences(of: " ", with: "")
    }
}

public class PANTextField: FormTextField {
    
    public init(theme: Theme) {
        super.init(
            title: "Card number",
            placeholder: "1234 1234 1234 1234",
            formatter: PANFormatter(),
            theme: theme
        )
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override var validationText: String {
        formattedPAN
    }
    
    var formattedPAN: String {
        textField.text?.replacingOccurrences(of: " ", with: "") ?? ""
    }
    
    override func textDidChange() {
        super.textDidChange()
        updateCardIcon()
    }

    private func setupView() {
        textField.keyboardType = .numberPad
        setIcon(GPAssets.icCardNumber.image, .Left)
        setIcon(GPAssets.icScanCard.image, .Right)
    }
    
    private func updateCardIcon() {
        let brand = CardBrandLibrary.detect(from: formattedPAN)
        setIcon(for: brand)
    }

    func setIcon(for cardBrand: CardBrand, _ side: TextFieldSide = .Right) {
        let image = CardBrandLibrary.cardBrandImage(for: cardBrand)
        guard let containerView = (side == .Left ? textField.leftView : textField.rightView) else {
            setupImageView(UIImageView(image: image), side)
            return
        }

        if let imageView = containerView.subviews.first as? UIImageView,
           imageView.image?.pngData() == image.pngData() {
            return // avoid redundant update
        }

        setupImageView(UIImageView(image: image), side)
    }
}
