//
//  UIViewController+.swift
//  GamePaySDKCoreUI
//
//  Created by Luke Nguyen on 25/7/25.
//

import UIKit

extension UIViewController {
    var rootParent: UIViewController {
        if let parent = parent {
            return parent.rootParent
        }
        return self
    }
    
    /// Use this to animate changes that affect the height of the sheet
    func animateHeightChange(forceAnimation: Bool = false, duration: CGFloat = 0.5, _ animations: (() -> Void)? = nil, postLayoutAnimations: (() -> Void)? = nil, completion: ((Bool) -> Void)? = nil)
    {
        guard forceAnimation || !isBeingPresented else {
            animations?()
            return
        }
        // Note: For unknown reasons, using `UIViewPropertyAnimator` here caused an infinite layout loop
        UIView.animate(
            withDuration: duration,
            delay: 0,
            usingSpringWithDamping: 1,
            initialSpringVelocity: 0,
            options: [],
            animations: {
                animations?()
                self.rootParent.presentationController?.containerView?.layoutIfNeeded()
                postLayoutAnimations?()
            }, completion: { f in
                completion?(f)
            }
        )
    }
    
    /// Convenience method that presents the view controller in a custom 'bottom sheet' style
    func presentAsBottomSheet(
        _ viewControllerToPresent: BottomSheetPresentable,
        theme: GPTheme,
        completion: (() -> Void)? = nil
    ) {
        var presentAsFormSheet: Bool {
            #if canImport(CompositorServices)
            return true
            #else
            // Present as form sheet in larger devices (iPad/Mac).
            if #available(iOS 14.0, macCatalyst 14.0, *) {
                return UIDevice.current.userInterfaceIdiom == .pad || UIDevice.current.userInterfaceIdiom == .mac
            } else {
                return UIDevice.current.userInterfaceIdiom == .pad
            }
            #endif
        }

        if presentAsFormSheet {
            viewControllerToPresent.modalPresentationStyle = .formSheet
            // Don't allow the pull down to dismiss gesture, it's too easy to trigger accidentally while scrolling
            viewControllerToPresent.isModalInPresentation = true
            if let vc = viewControllerToPresent as? BottomSheetViewController {
                viewControllerToPresent.presentationController?.delegate = vc
            }
        } else {
            viewControllerToPresent.modalPresentationStyle = .custom
            viewControllerToPresent.modalPresentationCapturesStatusBarAppearance = true
            BottomSheetTransitioningDelegate.theme = theme 
            viewControllerToPresent.transitioningDelegate = BottomSheetTransitioningDelegate.default
        }

        present(viewControllerToPresent, animated: true, completion: completion)
    }

    var bottomSheetController: BottomSheetViewController? {
        var current: UIViewController? = self
        while current != nil {
            if let bottomSheetController = current as? BottomSheetViewController {
                return bottomSheetController
            }

            current = current?.parent
        }

        return nil
    }
}
