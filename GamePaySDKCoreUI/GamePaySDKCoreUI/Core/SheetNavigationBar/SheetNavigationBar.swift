//
//  SheetNavigationBar.swift
//  GamePaySDKCoreUI
//
//  Created by Luke Nguyen on 25/7/25.
//

import UIKit

public protocol SheetNavigationBarDelegate: AnyObject {
    func sheetNavigationBarDidClose(_ sheetNavigationBar: SheetNavigationBar)
    func sheetNavigationBarDidBack(_ sheetNavigationBar: SheetNavigationBar)
}

public class SheetNavigationBar: UIView {
    public enum Style {
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
        stack.spacing = theme.appearance.padding
        stack.alignment = .center
        return stack
    }()
    
    lazy var closeButtonRight: UIButton = {
        let button = SheetNavigationButton(type: .custom)
        button.setImage(GPCoreUIAssets.icCloseNavBar.image.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = theme.colors.borderPrimary
        return button
    }()
    
    private let testView = TestModeView()
    
    lazy var backButton: UIButton = {
       let button = SheetNavigationButton(type: .custom)
       button.setImage(GPCoreUIAssets.icArrowBack.image.withRenderingMode(.alwaysTemplate), for: .normal)
       button.tintColor = theme.colors.borderPrimary
       return button
   }()
    
    // MARK: - Properties
    static let height: CGFloat = 48
    public weak var delegate: SheetNavigationBarDelegate?
    let theme: GPTheme
    private let isTestMode: Bool
    
    // MARK: - Lifecyles
    public init(isTestMode: Bool = false, theme: GPTheme) {
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
            leftItemsStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: theme.appearance.padding),
            leftItemsStackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            leftItemsStackView.trailingAnchor.constraint(lessThanOrEqualTo: closeButtonRight.leadingAnchor),
            leftItemsStackView.heightAnchor.constraint(equalTo: heightAnchor),

            closeButtonRight.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -theme.appearance.padding),
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
    public override var intrinsicContentSize: CGSize {
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

    public func setStyle(_ style: Style) {
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
