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
    
    public init(theme: GPTheme) {
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
    
    override func textDidChange() {
        super.textDidChange()
        updateCardIcon()
    }

    private func setupView() {
        textField.keyboardType = .numberPad
        setIcon(GPAssets.icCardNumber.image, on: .Left)
        setIcon(GPAssets.icScanCard.image, on: .Right)
    }
    
    private func updateCardIcon() {
        let brand = CardBrandLibrary.detect(from: validationText)
        setIcon(for: brand)
    }
    
    func setIcon(
        for cardBrand: CardBrand,
        on side: TextFieldSide = .Right,
        animated: Bool = false
    ) {
        let image = CardBrandLibrary.cardBrandImage(for: cardBrand)
        let currentContainer = (side == .Left ? textField.leftView : textField.rightView)

        // Avoid updating if the same image is already set
        if let existingImageView = currentContainer?.subviews.first as? UIImageView,
           existingImageView.image?.pngData() == image.pngData() {
            return
        }

        let imageView = UIImageView(image: image)
        applyIconView(imageView, on: side, animated: animated)
    }
}
