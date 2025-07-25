//
//  CardSchemeDetector.swift
//  GamePaySDK
//
//  Created by henry on 7/3/25.
//

import Foundation

// MARK: - CardSchemeValidator
protocol CardSchemeValidator {
    var cardBrand: CardBrand { get }
    func isValidCardScheme(cardNumber: String) -> Bool
}

extension CardSchemeValidator {
    func clearCardNumber(_ cardNumber: String) -> String {
        return cardNumber.replacingOccurrences(of: " ", with: "")
    }
}

struct VisaSchemeValidator: CardSchemeValidator {
    var cardBrand: CardBrand = .visa
    
    func isValidCardScheme(cardNumber: String) -> Bool {
        let clearCardNumber = self.clearCardNumber(cardNumber)
        return clearCardNumber.hasPrefix("4")
    }
}

struct MastercardSchemeValidator: CardSchemeValidator {
    var cardBrand: CardBrand = .mastercard
    
    func isValidCardScheme(cardNumber: String) -> Bool {
        let clearCardNumber = self.clearCardNumber(cardNumber)
        return clearCardNumber.hasPrefix("5")
    }
}

struct AmericanExpressSchemeValidator: CardSchemeValidator {
    var cardBrand: CardBrand = .amex
    
    func isValidCardScheme(cardNumber: String) -> Bool {
        let clearCardNumber = self.clearCardNumber(cardNumber)
        let amexPrefixes: [String] = ["34", "37"]
        for prefix in amexPrefixes {
            if clearCardNumber.hasPrefix(prefix) {
                return true
            }
        }
        return false
    }
}

struct UnionSchemeValidator: CardSchemeValidator {
    var cardBrand: CardBrand = .unionPay
    
    func isValidCardScheme(cardNumber: String) -> Bool {
        let clearCardNumber = self.clearCardNumber(cardNumber)
        return clearCardNumber.hasPrefix("62")
    }
}

struct DiscoverSchemeValidator: CardSchemeValidator {
    var cardBrand: CardBrand = .discover
    
    func isValidCardScheme(cardNumber: String) -> Bool {
        let clearCardNumber = self.clearCardNumber(cardNumber)
        return clearCardNumber.hasPrefix("6011")
    }
}

struct DinersClubSchemeValidator: CardSchemeValidator {
    var cardBrand: CardBrand = .dinersClub
    
    func isValidCardScheme(cardNumber: String) -> Bool {
        let clearCardNumber = self.clearCardNumber(cardNumber)
        let prefixes = ["300", "301", "302", "303", "304", "305", "36", "38", "39"]
        for prefix in prefixes {
            if clearCardNumber.hasPrefix(prefix) {
                return true
            }
        }
        return false
    }
}

struct JCBSchemeValidator: CardSchemeValidator {
    var cardBrand: CardBrand = .JCB
    
    func isValidCardScheme(cardNumber: String) -> Bool {
        let clearCardNumber = self.clearCardNumber(cardNumber)
        let prefixStart = 3528
        let prefixEnd = 3589
        if let prefix = Int(clearCardNumber.prefix(4)),
           prefix >= prefixStart && prefix <= prefixEnd {
            return true
        }
        return false
    }
}

// MARK: - CardSchemeDetector
struct CardSchemeDetector {
    static func detectCardScheme(_ cardNumber: String) -> CardBrand {
        let validators: [CardSchemeValidator] = [
            VisaSchemeValidator(),
            MastercardSchemeValidator(),
            AmericanExpressSchemeValidator(),
            DiscoverSchemeValidator(),
            DinersClubSchemeValidator(),
            JCBSchemeValidator(),
            UnionSchemeValidator()
        ]
        for validator in validators {
            if validator.isValidCardScheme(cardNumber: cardNumber) {
                return validator.cardBrand
            }
        }
        return .unknown
    }
}
