//
//  CardBrand.swift
//  GamePaySDKCoreUI
//
//  Created by Luke Nguyen on 24/7/25.
//

enum CardBrand: String, CaseIterable {
    /// Visa card
    case visa
    /// American Express card
    case amex = "american_express"
    /// Mastercard card
    case mastercard
    /// JCB card
    case JCB = "jcb"
    /// Discover card
    case discover
    /// Diners Club card
    case dinersClub = "diners_club"
    /// UnionPay card
    case unionPay = "unionpay"
    /// Cartes Bancaires
    case cartesBancaires = "cartes_bancaires"
    /// An unknown card brand type
    case unknown
}
