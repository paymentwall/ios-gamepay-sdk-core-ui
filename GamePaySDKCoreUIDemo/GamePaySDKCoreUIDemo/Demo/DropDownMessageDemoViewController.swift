//
//  DropDownMessageDemoViewController.swift
//  GamePaySDKCoreUIDemo
//
//  Created by henry on 7/28/25.
//

import UIKit
import GamePaySDKCoreUI

class DropDownMessageDemoViewController: UIViewController {

    // MARK: - UI Elements
    @IBOutlet weak var stvContainer: UIStackView!
    
    private lazy var btnInfo: GPPrimaryButton = {
        let btn = GPPrimaryButton(theme: theme)
        btn.config(title: "Show Info message") { [weak self] in
            guard let self else { return }
            showDropDownMessage(title: "Info", message: "It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using 'Content here, content here', making it look like readable English", type: .info, theme: theme) {
                print("On Tap Message")
            } onTapClose: {
                print("On Tap Close")
            }
        }
        return btn
    }()
    
    private lazy var btnSuccess: GPPrimaryButton = {
        let btn = GPPrimaryButton(theme: theme)
        btn.config(title: "Show Success message") { [weak self] in
            guard let self else { return }
            showDropDownMessage(title: "Success", message: "It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using 'Content here, content here', making it look like readable English", type: .success, theme: theme) {
                print("On Tap Message")
            } onTapClose: {
                print("On Tap Close")
            }
        }
        return btn
    }()
    
    private lazy var btnWarning: GPPrimaryButton = {
        let btn = GPPrimaryButton(theme: theme)
        btn.config(title: "Show Warning message") { [weak self] in
            guard let self else { return }
            showDropDownMessage(title: "Warning", message: "It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using 'Content here, content here', making it look like readable English", type: .warning, theme: theme) {
                print("On Tap Message")
            } onTapClose: {
                print("On Tap Close")
            }
        }
        return btn
    }()
    
    private lazy var btnError: GPPrimaryButton = {
        let btn = GPPrimaryButton(theme: theme)
        btn.config(title: "Show Error message") { [weak self] in
            guard let self else { return }
            showDropDownMessage(title: "Error", message: "It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using 'Content here, content here', making it look like readable English", type: .error, theme: theme) {
                print("On Tap Message")
            } onTapClose: {
                print("On Tap Close")
            }
        }
        return btn
    }()
    
    private let theme = GPThemeStore.defaultTheme
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let buttons = [btnInfo, btnSuccess, btnError, btnWarning]
        for button in buttons {
            stvContainer.addArrangedSubview(button)
        }
    }

}
