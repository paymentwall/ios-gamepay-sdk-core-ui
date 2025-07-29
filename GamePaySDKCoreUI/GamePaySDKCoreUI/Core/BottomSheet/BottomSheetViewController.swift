//
//  BottomSheetViewController.swift
//  GamePaySDK
//
//  Created by Luke Nguyen on 11/6/25.
//

import UIKit

protocol BottomSheetContentViewController: UIViewController {
    /// - Note: Implementing `navigationBar` as a computed variable will result in undefined behavior.
    var navigationBar: SheetNavigationBar { get }
    var requiresFullScreen: Bool { get }
    func didTapOrSwipeToDismiss()
}

class BottomSheetViewController: UIViewController, BottomSheetPresentable {
    struct Constants {
        static let keyboardAvoidanceEdgePadding: CGFloat = 16
    }
    // MARK: - UI Elements
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.automaticallyAdjustsScrollIndicatorInsets = false
        #if !os(visionOS)
        scrollView.keyboardDismissMode = .onDrag
        #endif
        scrollView.delegate = self
        return scrollView
    }()

    private lazy var navigationBarContainerView: UIStackView = {
        return UIStackView()
    }()

    private lazy var contentContainerView: UIStackView = {
        return UIStackView()
    }()

    private(set) var contentStack: [BottomSheetContentViewController] = []
    
    /// Content offset of the scroll view as a percentage (0 - 1.0) of the total height.
    var contentOffsetPercentage: CGFloat {
        get {
            guard scrollView.contentSize.height > scrollView.bounds.height else { return 0 }
            return scrollView.contentOffset.y / (scrollView.contentSize.height - scrollView.bounds.height)
        }
        set {
            let maxContentOffset = scrollView.contentSize.height - scrollView.bounds.height
            let newContentOffset = maxContentOffset * newValue
            scrollView.setContentOffset(CGPoint(x: 0, y: newContentOffset), animated: false)
        }
    }
    
    private var contentViewController: BottomSheetContentViewController
    let theme: GPTheme
    
    var contentRequiresFullScreen: Bool {
        return contentViewController.requiresFullScreen
    }
    
    // MARK: - Lifecycle
    required init(contentViewController: BottomSheetContentViewController, theme: GPTheme) {
        self.contentViewController = contentViewController
        self.theme = theme
        
        super.init(nibName: nil, bundle: nil)

        contentStack = [contentViewController]

        addChild(contentViewController)
        contentViewController.didMove(toParent: self)
        contentContainerView.addArrangedSubview(contentViewController.view)
        navigationBarContainerView.addArrangedSubview(contentViewController.navigationBar)
        self.view.backgroundColor = theme.colors.bgDefaultLight
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    // MARK: - Setup
    private var scrollViewHeightConstraint: NSLayoutConstraint?
    private var bottomAnchor: NSLayoutConstraint?
    
    private func setupView() {
        view.backgroundColor = .systemBackground
        registerForKeyboardNotifications()
        
        [scrollView, navigationBarContainerView].forEach({  // Note: Order important here, navigation bar should be on top
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        })
        
        scrollView.contentInsetAdjustmentBehavior = .never
        let bottomAnchor = scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        bottomAnchor.priority = .defaultLow
        self.bottomAnchor = bottomAnchor
        
        NSLayoutConstraint.activate([
            navigationBarContainerView.topAnchor.constraint(equalTo: view.topAnchor),  // For unknown reasons, safeAreaLayoutGuide can have incorrect padding; we'll rely on our superview instead
            navigationBarContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navigationBarContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            scrollView.topAnchor.constraint(equalTo: navigationBarContainerView.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            bottomAnchor,
        ])
        
        contentContainerView.translatesAutoresizingMaskIntoConstraints = false
        contentContainerView.directionalLayoutMargins = NSDirectionalEdgeInsets(
            top: 0,
            leading: theme.appearance.padding,
            bottom: 40,
            trailing: theme.appearance.padding
        )
        scrollView.addSubview(contentContainerView)
        
        // Give the scroll view a desired height
        let scrollViewHeightConstraint = scrollView.heightAnchor.constraint(
            equalTo: scrollView.contentLayoutGuide.heightAnchor)
        scrollViewHeightConstraint.priority = .fittingSizeLevel
        self.scrollViewHeightConstraint = scrollViewHeightConstraint
        
        NSLayoutConstraint.activate([
            contentContainerView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentContainerView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentContainerView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentContainerView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentContainerView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
            scrollViewHeightConstraint,
        ])
        
        let hideKeyboardGesture = UITapGestureRecognizer(
            target: self, action: #selector(didTapAnywhere))
        hideKeyboardGesture.cancelsTouchesInView = false
        hideKeyboardGesture.delegate = self
        view.addGestureRecognizer(hideKeyboardGesture)
    }
    
    private func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(
            self, selector: #selector(keyboardDidHide),
            name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(
            self, selector: #selector(keyboardDidShow),
            name: UIResponder.keyboardWillShowNotification, object: nil)
    }

    @objc
    private func keyboardDidShow(notification: Notification) {
        adjustForKeyboard(notification: notification) {
            if let firstResponder = self.view.firstResponder() {
                let firstResponderFrame = self.scrollView.convert(firstResponder.bounds, from: firstResponder).insetBy(
                    dx: -Constants.keyboardAvoidanceEdgePadding,
                    dy: -Constants.keyboardAvoidanceEdgePadding
                )
                self.scrollView.scrollRectToVisible(firstResponderFrame, animated: true)
            }
        }
    }

    @objc
    private func keyboardDidHide(notification: Notification) {
        adjustForKeyboard(notification: notification) {
            if let firstResponder = self.view.firstResponder() {
                let firstResponderFrame = self.scrollView.convert(firstResponder.bounds, from: firstResponder).insetBy(
                    dx: -Constants.keyboardAvoidanceEdgePadding,
                    dy: -Constants.keyboardAvoidanceEdgePadding
                )
                self.scrollView.scrollRectToVisible(firstResponderFrame, animated: true)
            }
        }
    }
    
    @objc
    private func adjustForKeyboard(notification: Notification, animations: @escaping () -> Void) {
        guard presentedViewController == nil else {
            // The presentedVC handles the keyboard, not us.
            return
        }
        let adjustForKeyboard = {
            self.view.superview?.setNeedsLayout()
            UIView.animateAlongsideKeyboard(notification) {
                guard
                    let keyboardScreenEndFrame =
                        (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?
                        .cgRectValue,
                    let bottomAnchor = self.bottomAnchor
                else {
                    return
                }

                let keyboardViewEndFrame = self.view.convert(keyboardScreenEndFrame, from: self.view.window)
                var keyboardInViewHeight = self.view.bounds.intersection(keyboardViewEndFrame).height
                // Account for edge case where keyboard is taller than our view
                if keyboardViewEndFrame.origin.y < 0 {
                    // If keyboard frame is negative relative to our own, keyboardInViewHeight (the intersection of keyboard and our view) won't include it and we need to add the extra height:
                    keyboardInViewHeight += -keyboardViewEndFrame.origin.y
                }
                if notification.name == UIResponder.keyboardWillHideNotification {
                    bottomAnchor.constant = 0
                } else {
                    bottomAnchor.constant = -keyboardInViewHeight
                }

                self.view.superview?.layoutIfNeeded()
                animations()
            }
        }
        if self.modalPresentationStyle == .formSheet {
            // If we're presenting as a form sheet (on an iPad etc), the form sheet presenter might move us around to center us on the screen.
            // Then we can't calculate the keyboard's location correctly, because we'll be estimating based on the keyboard's size
            // in our *old* location instead of the new one.
            // To work around this, wait for a turn of the runloop, then add the keyboard padding.
            DispatchQueue.main.async {
                adjustForKeyboard()
            }
        } else {
            // But usually we can do this immediately, as we control the presentation and know we'll always be pinned to the bottom of the screen.
            adjustForKeyboard()
        }
    }
    
    // MARK: - Set ViewControllers
    private lazy var manualHeightConstraint: NSLayoutConstraint = {
        let manualHeightConstraint: NSLayoutConstraint = self.view.heightAnchor.constraint(equalToConstant: 0)
        manualHeightConstraint.priority = .defaultHigh
        return manualHeightConstraint
    }()
    
    var completeBottomSheetPresentationTransition: ((Bool) -> Void)?
    
    func setViewControllers(_ viewControllers: [BottomSheetContentViewController]) {
        contentStack = viewControllers
        if let top = viewControllers.first {
            updateContent(to: top)
        }
    }
    
    func updateContent(to newContentViewController: BottomSheetContentViewController, completion: (() -> Void)? = nil) {
        guard contentViewController !== newContentViewController else {
            return
        }
        let oldContentViewController = contentViewController
        contentViewController = newContentViewController
        // Handle edge case where BottomSheetPresentationAnimator is mid-presentation
        // We need to finish *that* transition before starting this one.
        completeBottomSheetPresentationTransition?(true)

        // This is a hack to get the animation right.
        // Instead of allowing the height change to implicitly occur within
        // the animation block's layoutIfNeeded, we force a layout pass,
        // calculate the old and new heights, and then only animate the height
        // constraint change.
        // Without this, the inner ScrollView tends to animate from the center
        // instead of remaining pinned to the top.

        // First, get the old height of the content + navigation bar + safe area.
        manualHeightConstraint.constant = oldContentViewController.view.frame.size.height + navigationBarContainerView.bounds.size.height

        // Take a snapshot of the old content and add it to our container - we'll fade it out
        let oldView = oldContentViewController.view!
        let oldViewImage = oldView.snapshotView(afterScreenUpdates: false) ?? UIView()
        contentContainerView.addSubview(oldViewImage)

        // Remove the old VC
        oldContentViewController.beginAppearanceTransition(false, animated: true)
        oldContentViewController.view.removeFromSuperview()
        oldContentViewController.endAppearanceTransition()

        // Add the new VC
        newContentViewController.beginAppearanceTransition(true, animated: true)
        // When your custom container calls the addChild(_:) method, it automatically calls the willMove(toParent:) method of the view controller to be added as a child before adding it.
        addChild(newContentViewController)
        contentContainerView.addArrangedSubview(self.contentViewController.view)
        if let presentationController = rootParent.presentationController as? BottomSheetPresentationController {
            presentationController.forceFullHeight = newContentViewController.requiresFullScreen
        }

        contentContainerView.layoutIfNeeded()
        scrollView.layoutIfNeeded()
        scrollView.updateConstraintsIfNeeded()
        oldContentViewController.navigationBar.removeFromSuperview()
        navigationBarContainerView.addArrangedSubview(newContentViewController.navigationBar)
        navigationBarContainerView.layoutIfNeeded()
        // Layout is mostly completed at this point. The new height is the navigation bar + content
        let newHeight = newContentViewController.view.bounds.size.height + navigationBarContainerView.bounds.size.height

        // Force the old height, then force a layout pass
        if modalPresentationStyle == .custom { // Only if we're using the custom presentation style (e.g. pinned to the bottom)
            manualHeightConstraint.isActive = true
        }
        rootParent.presentationController?.containerView?.layoutIfNeeded()
        newContentViewController.view.alpha = 0
        // Now animate to the correct height.
        UIView.animate(withDuration: 0.2) {
            // Fade old content snapshot out
            oldViewImage.alpha = 0
        }
        animateHeightChange(forceAnimation: true, {
            // Fade new content in
            self.contentViewController.view.alpha = 1
            self.manualHeightConstraint.constant = newHeight
        }, completion: {_ in
            // If you are implementing your own container view controller, it must call the didMove(toParent:) method of the child view controller after the transition to the new controller is complete or, if there is no transition, immediately after calling the addChild(_:) method.
            self.contentViewController.didMove(toParent: self)
            self.contentViewController.endAppearanceTransition()

            // Remove the old content snapshot
            oldViewImage.removeFromSuperview()

            // Inform accessibility
            UIAccessibility.post(notification: .screenChanged, argument: self.contentViewController.view)

            // We shouldn't need this constraint anymore.
            self.manualHeightConstraint.isActive = false

            completion?()
        })
    }
    
    func didTapOrSwipeToDismiss() {
        contentViewController.didTapOrSwipeToDismiss()
    }
}

extension BottomSheetViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > 0 {
            contentViewController.navigationBar.setShadowHidden(false)
        } else {
            contentViewController.navigationBar.setShadowHidden(true)
        }
    }
}

extension BottomSheetViewController: UIAdaptivePresentationControllerDelegate {
    func presentationControllerShouldDismiss(_ presentationController: UIPresentationController) -> Bool {
        // On iPad, tapping outside the sheet dismisses it without informing us - so we override this method to be informed.
        didTapOrSwipeToDismiss()
        return false
    }
}

// MARK: - UIGestureRecognizerDelegate
extension BottomSheetViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(
        _ gestureRecognizer: UIGestureRecognizer,
        shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer
    ) -> Bool {
        return true
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch)
        -> Bool
    {
        // I can't find another way to allow custom UIControl subclasses to receive touches
        return !(touch.view is UIControl)
    }

    @objc func didTapAnywhere() {
        view.endEditing(false)
    }
}
