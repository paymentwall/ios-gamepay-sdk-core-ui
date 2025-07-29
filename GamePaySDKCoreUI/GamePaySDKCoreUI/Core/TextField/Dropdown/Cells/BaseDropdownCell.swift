//
//  BaseDropdownCell.swift
//  GamePaySDKCoreUI
//
//  Created by Luke Nguyen on 25/7/25.
//

import UIKit

class BaseDropdownCell: UITableViewCell {
    open class var estimatedHeight: CGFloat {
        return 64
    }
    
    var isSelectedCell: Bool = false
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func configureCell(with option: DropdownOption, theme: GPTheme) {
        
    }
}
