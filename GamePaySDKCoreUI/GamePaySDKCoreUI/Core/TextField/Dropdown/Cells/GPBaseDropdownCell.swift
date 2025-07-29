//
//  GPBaseDropdownCell.swift
//  GamePaySDKCoreUI
//
//  Created by Luke Nguyen on 25/7/25.
//

import UIKit

class GPBaseDropdownCell: UITableViewCell {
    /// Estimated height used for layout calculation
    open class var estimatedHeight: CGFloat {
        return 64
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Configure the cell with a dropdown option and theme
    /// Subclasses must override to populate UI
    /// - Parameters:
    ///   - option: The dropdown option model
    ///   - isSelectedCell: Boolean to show cell is selected
    ///   - theme: Theme for consistent styling
    open func configureCell(with option: GPDropdownOption, isSelectedCell: Bool, theme: GPTheme) {
        
    }
}
