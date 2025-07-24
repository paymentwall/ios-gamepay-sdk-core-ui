//
//  ViewController.swift
//  GamePaySDKCoreUIDemo
//
//  Created by henry on 7/23/25.
//

import UIKit
import GamePaySDKCoreUI

class ViewController: UIViewController {
    
    // MARK: - UI Elements
    @IBOutlet weak var stvContainer: UIStackView!
    lazy var demoButton: UIButton = {
        let btn = DemoButton(theme: theme)
        btn.setTitle("Demo button", for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.widthAnchor.constraint(equalToConstant: 200).isActive = true
        return btn
    }()
    
    // MARK: - Properties
    private let theme = ThemeStore.defaultTheme
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stvContainer.addArrangedSubview(demoButton)
    }

}

