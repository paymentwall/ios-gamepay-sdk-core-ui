//
//  BottomSheetTransitioningDelegate.swift
//  GamePaySDK
//
//  Created by Luke Nguyen on 11/6/25.
//


import UIKit

/// The BottomSheetTransitioningDelegate conforms to the various transition delegates
/// and vends the appropriate object for each transition controller requested.
///
/// Usage:
/// ```
/// viewController.modalPresentationStyle = .custom
/// viewController.transitioningDelegate = BottomSheetTransitioningDelegate.default
/// ```
public class BottomSheetTransitioningDelegate: NSObject {

    static var theme: GPTheme = GPThemeStore.defaultTheme

    /**
     Returns an instance of the delegate, retained for the duration of presentation
     */
    static var `default`: BottomSheetTransitioningDelegate = {
        return BottomSheetTransitioningDelegate()
    }()

}

extension BottomSheetTransitioningDelegate: UIViewControllerTransitioningDelegate {

    /**
     Returns a modal presentation animator configured for the presenting state
     */
    public func animationController(
        forPresented presented: UIViewController,
        presenting: UIViewController,
        source: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
        return BottomSheetPresentationAnimator(transitionStyle: .presentation)
    }

    /**
     Returns a modal presentation animator configured for the dismissing state
     */
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return BottomSheetPresentationAnimator(transitionStyle: .dismissal)
    }

    /**
     Returns a modal presentation controller to coordinate the transition from the presenting
     view controller to the presented view controller.
     */
    public func presentationController(
        forPresented presented: UIViewController,
        presenting: UIViewController?,
        source: UIViewController
    ) -> UIPresentationController? {
        let controller = BottomSheetPresentationController(presentedViewController: presented, presenting: presenting)
        controller.forceFullHeight = (presented as? BottomSheetViewController)?.contentRequiresFullScreen ?? false
        return controller
    }
}
