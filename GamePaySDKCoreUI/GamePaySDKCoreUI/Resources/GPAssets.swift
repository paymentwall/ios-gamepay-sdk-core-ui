//
//  PaymentSheet+Image.swift
//  GamePaySDK
//
//  Created by Luke Nguyen on 11/6/25.
//

import UIKit

public class BundleProvider { }
let GamePaySDKCoreUIBundle = Bundle(for: BundleProvider.self)

enum GPAssets: String {
    var image: UIImage {
        return UIImage(named: self.rawValue,
                       in: GamePaySDKCoreUIBundle,
                       compatibleWith: nil) ?? UIImage()
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
    case icWarning = "ic_warning"
    case icDropdown = "ic_dropdown"
    case icSearch = "ic_search"
}
