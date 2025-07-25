//
//  SheetNavigationBar.swift
//  GamePaySDKCoreUI
//
//  Created by Luke Nguyen on 25/7/25.
//

import UIKit

protocol SheetNavigationBarDelegate: AnyObject {
    func sheetNavigationBarDidClose(_ sheetNavigationBar: SheetNavigationBar)
    func sheetNavigationBarDidBack(_ sheetNavigationBar: SheetNavigationBar)
}

class SheetNavigationBar: UIView {
    enum Style {
        case close(showAdditionalButton: Bool)
        case back(showAdditionalButton: Bool)
        case none
    }
    
    // MARK: - UI Elements
    lazy var leftItemsStackView: UIStackView = {
        var subviews: [UIView] = [backButton]
        if isTestMode {
            subviews.append(testView)
        }
        let stack = UIStackView(arrangedSubviews: subviews)
        // TODO: Update padding
        stack.spacing = 16
        stack.alignment = .center
        return stack
    }()
    
    lazy var closeButtonRight: UIButton = {
        let button = SheetNavigationButton(type: .custom)
        button.setImage(GPAssets.icCloseNavBar.image.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = theme.colors.borderPrimary
        return button
    }()
    
    private let testView = TestModeView()
    
    lazy var backButton: UIButton = {
       let button = SheetNavigationButton(type: .custom)
       button.setImage(GPAssets.icArrowBack.image.withRenderingMode(.alwaysTemplate), for: .normal)
       button.tintColor = theme.colors.borderPrimary
       return button
   }()
    
    // MARK: - Properties
    static let height: CGFloat = 48
    weak var delegate: SheetNavigationBarDelegate?
    let theme: Theme
    private let isTestMode: Bool
    
    // MARK: - Lifecyles
    init(isTestMode: Bool = false, theme: Theme) {
        self.theme = theme
        self.isTestMode = isTestMode
        super.init(frame: .zero)
        #if !canImport(CompositorServices)
        backgroundColor = theme.colors.bgDefaultLight.withAlphaComponent(0.9)
        #endif
        
        [leftItemsStackView, closeButtonRight].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            // TODO: Update padding
            leftItemsStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            leftItemsStackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            leftItemsStackView.trailingAnchor.constraint(lessThanOrEqualTo: closeButtonRight.leadingAnchor),
            leftItemsStackView.heightAnchor.constraint(equalTo: heightAnchor),

            closeButtonRight.trailingAnchor.constraint(
                // TODO: Update padding
                equalTo: trailingAnchor, constant: -16),
            closeButtonRight.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
        
        closeButtonRight.addTarget(self, action: #selector(didTapCloseButton), for: .touchUpInside)
        backButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        
        setStyle(.close(showAdditionalButton: false))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setups
    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: Self.height)
    }
    
    @objc
    private func didTapCloseButton() {
        delegate?.sheetNavigationBarDidClose(self)
    }
    
    @objc
    private func didTapBackButton() {
        delegate?.sheetNavigationBarDidBack(self)
    }

    func setStyle(_ style: Style) {
        switch style {
        case .back(_):
            closeButtonRight.isHidden = true
            backButton.isHidden = false
            bringSubviewToFront(backButton)
            
        case .close(let showAdditionalButton):
            closeButtonRight.isHidden = showAdditionalButton
            backButton.isHidden = true
            
        case .none:
            closeButtonRight.isHidden = true
            backButton.isHidden = true
        }
    }
    
    func setShadowHidden(_ isHidden: Bool) {
        layer.shadowPath = CGPath(rect: bounds, transform: nil)
        layer.shadowOpacity = isHidden ? 0 : 0.1
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2)
    }
}
