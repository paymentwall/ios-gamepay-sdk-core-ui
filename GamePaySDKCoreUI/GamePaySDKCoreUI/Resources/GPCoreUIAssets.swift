//
//  PaymentSheet+Image.swift
//  GamePaySDK
//
//  Created by Luke Nguyen on 11/6/25.
//

import UIKit

public class BundleProvider { }

// Use a more reliable way to get the bundle that works with SPM
public let GamePaySDKCoreUIBundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleProvider.self)
    #endif
}()

public enum GPCoreUIAssets: String {
    public var image: UIImage {
        return UIImage(named: self.rawValue,
                       in: GamePaySDKCoreUIBundle,
                       compatibleWith: nil) ?? UIImage()
    }
    
    public var color: UIColor {
        return UIColor(named: self.rawValue,
                       in: GamePaySDKCoreUIBundle,
                       compatibleWith: nil) ?? UIColor()
    }
    
    // MARK: - Images
    case icCloseNavBar = "ic_close_nav_bar"
    case icArrowBack = "ic_arrow_back"
    case cardLogo = "card_logo"
    case icCardNumber = "ic_tf_card_number"
    case icAddNewCard = "ic_add_new_card"
    case icRemoveSavedCard = "ic_remove_saved_card"
    case icScanCard = "ic_scan_card"
    case icCVV = "ic_cvv"
    case icCheckboxSelected = "ic_checkbox_selected"
    case icCheckboxUnselected = "ic_checkbox_unselected"
    case icLoading = "ic_loading"
    case icMore = "ic_more"
    case ic_success
    case ic_declined
    case logoFooter = "logo_footer"
    case icCheckmark = "ic_checkmark"
    case icError = "ic_error"
    case icDropdown = "ic_dropdown"
    case icSearch = "ic_search"
    case icWarning = "ic_warning"
    case icInfo = "ic_info"
    
    // MARK: - Colors
    case white000 = "White000"
    case lavender050 = "Lavender050"
    case lavender100 = "Lavender100"
    case lavender200 = "Lavender200"
    case lavender300 = "Lavender300"
    case steelBlue300 = "SteelBlue300"
    case steelBlue500 = "SteelBlue500"
    case steelBlue800 = "SteelBlue800"
    case steelBlue900 = "SteelBlue900"
    case semanticBlue800 = "SemanticBlue800"
    case semanticYellow800 = "SemanticYellow800"
    case semanticRed800 = "SemanticRed800"
    case semanticGreen800 = "SemanticGreen800"
    case backgroundBlue700 = "BackgroundBlue700"
    case backgroundYellow700 = "BackgroundYellow700"
    case backgroundRed700 = "BackgroundRed700"
    case backgroundGreen700 = "BackgroundGreen700"
    case backgroundBlack900 = "BackgroundBlack900"
    case accentDarkBlue900 = "AccentDarkBlue900"
}
