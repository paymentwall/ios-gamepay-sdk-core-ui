//
//  DropdownSheetViewController.swift
//  GamePaySDKCoreUI
//
//  Created by Luke Nguyen on 25/7/25.
//

import UIKit

class DropdownSheetViewController: UIViewController {
    let options: [DropdownOption]
    let navBarTitle: String
    let theme: Theme
    let selectedOption: DropdownOption?
    var onSelect: ((DropdownOption) -> Void)?
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.automaticallyAdjustsScrollIndicatorInsets = false
        #if !os(visionOS)
        scrollView.keyboardDismissMode = .onDrag
        #endif
        return scrollView
    }()
    private let navBar = UIView()
    private let closeButton = UIButton(type: .system)
    private var contentContainerView: UIStackView = {
        let stv = UIStackView()
        stv.axis = .vertical
        stv.translatesAutoresizingMaskIntoConstraints = false
        return stv
    }()
    
    init(
        options: [DropdownOption],
        selectedOption: DropdownOption? = nil,
        navBarTitle: String,
        theme: Theme
    ) {
        self.options = options
        self.selectedOption = selectedOption
        self.navBarTitle = navBarTitle
        self.theme = theme
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = theme.colors.bgDefaultLight
        setupUI()
        setupView()
    }
    
    // MARK: - Setup UI
    private var scrollViewHeightConstraint: NSLayoutConstraint?
    private var bottomAnchor: NSLayoutConstraint?
    
    private func setupUI() {
        let titleLabel = UILabel()
        titleLabel.text = navBarTitle
        titleLabel.font = theme.typography.bodyMedium1
        closeButton.setImage(GPAssets.icCloseNavBar.image, for: .normal)
        closeButton.tintColor = .label
        closeButton.addTarget(self, action: #selector(dismissSheet), for: .touchUpInside)
        let barStack = UIStackView(arrangedSubviews: [titleLabel, UIView(), closeButton])
        barStack.axis = .horizontal
        barStack.alignment = .center
        barStack.spacing = 16
        barStack.translatesAutoresizingMaskIntoConstraints = false
        
        navBar.backgroundColor = theme.colors.bgDefaultLight
        navBar.addSubview(barStack)
        
        [navBar, scrollView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        scrollView.contentInsetAdjustmentBehavior = .never
        let bottomAnchor = scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        bottomAnchor.priority = .defaultLow
        self.bottomAnchor = bottomAnchor
        
        NSLayoutConstraint.activate([
            // TODO: Update defaultPadding
            barStack.leadingAnchor.constraint(equalTo: navBar.leadingAnchor, constant: 16),
            barStack.trailingAnchor.constraint(equalTo: navBar.trailingAnchor, constant: -16),
            barStack.centerYAnchor.constraint(equalTo: navBar.centerYAnchor),
            navBar.topAnchor.constraint(equalTo: view.topAnchor, constant: 8),
            navBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            navBar.heightAnchor.constraint(equalToConstant: 48),
            
            scrollView.topAnchor.constraint(equalTo: navBar.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomAnchor,
        ])
        
        contentContainerView.translatesAutoresizingMaskIntoConstraints = false
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
    }
    
    private func setupView() {
        for option in options {
            if let option = option as? DropdownPhoneOption {
                let phoneOption = PhoneOptionView(theme: theme)
                phoneOption.configure(with: option, delegate: self)
                contentContainerView.addArrangedSubview(phoneOption)
                continue
            }
            
            let optionView = DropdownIconTextView(theme: theme)
            let isSelected = option.value == selectedOption?.value
            optionView.configure(with: option, delegate: self, isSelected: isSelected)
            contentContainerView.addArrangedSubview(optionView)
        }
        
        // Scroll to selected cell
        if let selectedOption = selectedOption,
           let index = options.firstIndex(where: { $0.value == selectedOption.value }),
           index < contentContainerView.arrangedSubviews.count {

            let targetView = contentContainerView.arrangedSubviews[index]

            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                let targetFrameInScrollView = scrollView.convert(targetView.frame, from: contentContainerView)
                let scrollViewHeight = scrollView.bounds.height
                let centeredOffsetY = targetFrameInScrollView.midY - scrollViewHeight / 2
                let maxOffsetY = scrollView.contentSize.height - scrollViewHeight
                let adjustedOffsetY = max(0, min(centeredOffsetY, maxOffsetY))
                
                scrollView.setContentOffset(CGPoint(x: 0, y: adjustedOffsetY), animated: false)
            }
        }
    }
    
    @objc private func dismissSheet() {
        dismiss(animated: true)
    }
}

extension DropdownSheetViewController: DropdownOptionViewDelegate {
    func didSelectOption(_ option: DropdownOption) {
        onSelect?(option)
        dismissSheet()
    }
}

extension DropdownSheetViewController: BottomSheetPresentable {
    func didTapOrSwipeToDismiss() {
        dismissSheet()
    }
}
