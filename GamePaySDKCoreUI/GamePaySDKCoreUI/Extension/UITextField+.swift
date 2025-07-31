//
//  UITextField+.swift
//  GamePaySDKCoreUI
//
//  Created by Luke Nguyen on 24/7/25.
//

import UIKit

extension UITextField {
    func setPaddingPoints(_ amount: CGFloat, side: TextFieldSide) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.height))
        setViewBySide(paddingView, side)
    }
    
    func setViewBySide(_ view: UIView, _ side: TextFieldSide) {
        switch side {
        case .Left:
            leftView = view
            leftViewMode = .always
        case .Right:
            rightView = view
            rightViewMode = .always
        case .Both:
            leftView = view
            leftViewMode = .always
            rightView = view
            rightViewMode = .always
        }
    }
}
