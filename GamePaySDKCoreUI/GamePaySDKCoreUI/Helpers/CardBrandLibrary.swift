//
//  CardBrandLibrary.swift
//  GamePaySDKCoreUI
//
//  Created by Luke Nguyen on 24/7/25.
//

import UIKit

// MARK: - CardBrandLibrary
class CardBrandLibrary {
    /// This returns the array icons of all card brand.
    static var orderedCardIconImages: [UIImage] = {
        let supportedBrands: [CardBrand] = [.mastercard, .visa, .amex, .discover, .dinersClub, .JCB]
        return supportedBrands.map { cardBrandImage(for: $0) }
    }()
    
    /// This returns the appropriate icon for the specified card brand.
    class func cardBrandImage(for brand: CardBrand) -> UIImage {
        var imageName: String
        
        switch brand {
        case .visa:
            imageName = "visa"
        case .amex:
            imageName = "amex"
        case .mastercard:
            imageName = "mastercard"
        case .discover:
            imageName = "discover"
        case .JCB:
            imageName = "jcb"
        case .dinersClub:
            imageName = "diners_club"
        case .unionPay:
            imageName = "unionpay"
        case .cartesBancaires:
            imageName = "cartes_bancaires"
        case .unknown:
            imageName = "ic_scan_card"
        }
        
        return UIImage(named: imageName,
                       in: GamePaySDKCoreUIBundle,
                       compatibleWith: nil) ?? UIImage()
    }
    
    class func cardBrandImage(fromString cardStr: String) -> UIImage {
        let cardBrand = CardBrand(rawValue: cardStr.lowercased()) ?? .unknown
        return cardBrandImage(for: cardBrand)
    }
    
    class func detect(from cardNumber: String) -> CardBrand {
        CardSchemeDetector.detectCardScheme(cardNumber)
    }
}
