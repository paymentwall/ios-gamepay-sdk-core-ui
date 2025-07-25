//
//  UIView+.swift
//  GamePaySDKCoreUI
//
//  Created by henry on 7/24/25.
//

import UIKit

extension UIView {
    func addAndPinSubview(_ view: UIView, insets: NSDirectionalEdgeInsets = .zero) {
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: topAnchor, constant: insets.top),
            view.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -insets.bottom),
            view.leadingAnchor.constraint(equalTo: leadingAnchor, constant: insets.leading),
            view.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -insets.trailing),
        ])
    }
    
    /// Animates changes to one or more views alongside the keyboard.
    ///
    /// - Parameters:
    ///   - notification: Keyboard change notification.
    ///   - animations: A block containing the changes to commit to the views.
    static func animateAlongsideKeyboard(
        _ notification: Notification,
        animations: @escaping () -> Void
    ) {

        guard let userInfo = notification.userInfo,
              let animationCurveValue = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? Int,
              let animationDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double,
              let animationCurve = UIView.AnimationCurve(rawValue: animationCurveValue),
              animationDuration > 0 else {
            // Just run the animation block as a fallback
            animations()
            return
        }

        // Animate the container above the keyboard
        // Note: We prefer UIViewPropertyAnimator over UIView.animate because it handles consecutive animation calls better. Sometimes this happens when one text field resigns and another immediately becomes first responder.
        let animator = UIViewPropertyAnimator(duration: animationDuration, curve: animationCurve) {
            animations()
        }
        animator.startAnimation()
    }
    
    func firstResponder() -> UIView? {
        for subview in subviews {
            if let firstResponder = subview.firstResponder() {
                return firstResponder
            }
        }
        return isFirstResponder ? self : nil
    }
}
