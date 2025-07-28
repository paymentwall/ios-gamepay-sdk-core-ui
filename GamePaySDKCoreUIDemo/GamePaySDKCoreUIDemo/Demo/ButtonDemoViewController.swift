//
//  ButtonDemoViewController.swift
//  GamePaySDKCoreUIDemo
//
//  Created by henry on 7/25/25.
//

import UIKit
import GamePaySDKCoreUI

class ButtonDemoViewController: UIViewController {
    
    @IBOutlet weak var stvContainer: UIStackView!
    lazy var btnPrimaryActive: GPPrimaryButton = {
        let btn = GPPrimaryButton(theme: theme)
        btn.config(title: "Primary Active", icon: GPAssets.ic_success.image.withRenderingMode(.alwaysTemplate)) {
            btn.setState(.loading)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                btn.setState(.success)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    btn.setState(.active)
                }
            }
        }
        return btn
    }()
    
    lazy var btnPrimaryInactive: GPPrimaryButton = {
        let btn = GPPrimaryButton(theme: theme)
        btn.config(title: "Primary Inactive") {
            print("Primary Inactive Tap")
        }
        btn.setState(.inactive)
        return btn
    }()
    
    lazy var btnSecondaryActive: GPSecondaryButton = {
        let btn = GPSecondaryButton(theme: theme)
        btn.config(title: "Secondary Active") {
            print("Secondary Active Tap")
        }
        return btn
    }()
    
    lazy var btnSecondaryInactive: GPSecondaryButton = {
        let btn = GPSecondaryButton(theme: theme)
        btn.config(title: "Secondary Active") {
            print("Secondary Active Tap")
        }
        btn.setState(.inactive)
        return btn
    }()
    
    lazy var btnSecondaryOutlinedActive: GPSecondaryButton = {
        let btn = GPSecondaryButton(theme: theme)
        btn.config(title: "Secondary Active") {
            print("Secondary Active Tap")
        }
        btn.isOutlined = true
        return btn
    }()
    
    lazy var btnQuaternaryActive: GPQuaternaryButton = {
        let btn = GPQuaternaryButton(theme: theme)
        btn.config(title: "Quaternary Active") {
            print("Quaternary Active Tap")
        }
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    private let theme = GPThemeStore.defaultTheme
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let buttons = [btnPrimaryActive, btnPrimaryInactive, btnSecondaryActive, btnSecondaryInactive, btnSecondaryOutlinedActive]
        for button in buttons {
            stvContainer.addArrangedSubview(button)
        }
        view.addSubview(btnQuaternaryActive)
        NSLayoutConstraint.activate([
            btnQuaternaryActive.topAnchor.constraint(equalTo: stvContainer.bottomAnchor, constant: 16),
            btnQuaternaryActive.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
}
