//
//  GPDivider.swift
//  GamePaySDKCoreUI
//
//  Created by henry on 8/1/25.
//

import UIKit

public class GPDivider: UIView {
    private let color: UIColor
    private let height: CGFloat
    
    public init(color: UIColor = GPCoreUIAssets.lavender100.color, height: CGFloat = 1) {
        self.color = color
        self.height = height
        super.init(frame: .zero)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        backgroundColor = color
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: height).isActive = true
    }
}
