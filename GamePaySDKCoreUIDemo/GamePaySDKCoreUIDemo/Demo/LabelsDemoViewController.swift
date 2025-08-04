//
//  LabelsDemoViewController.swift
//  GamePaySDKCoreUIDemo
//
//  Created by henry on 8/1/25.
//

import UIKit
import GamePaySDKCoreUI

class LabelsDemoViewController: UIViewController {
    
    @IBOutlet var contentStackView: UIStackView!
    
    // MARK: - Properties
    private let theme = GPThemeStore.defaultTheme
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLabels()
    }
    
    // MARK: - Setup
    private func setupLabels() {
        // Heading Labels
        addSection(title: "Heading Labels")
        addLabel(GPHeading1Label(theme: theme), text: "Heading 1 - Main Title")
        addLabel(GPHeading2Label(theme: theme), text: "Heading 2 - Section Title")
        addLabel(GPHeading3Label(theme: theme), text: "Heading 3 - Subsection Title")
        addLabel(GPHeading4Label(theme: theme), text: "Heading 4 - Card Title")
        addLabel(GPHeading5Label(theme: theme), text: "Heading 5 - Small Title")
        
        // Label Styles
        addSection(title: "Label Styles")
        addLabel(GPLabel1Label(theme: theme), text: "Label 1 - Primary Label")
        addLabel(GPLabel2Label(theme: theme), text: "Label 2 - Secondary Label")
        
        // Button Labels
        addSection(title: "Button Labels")
        addLabel(GPButton1Label(theme: theme), text: "Button 1 - Primary Button Text")
        addLabel(GPButton2Label(theme: theme), text: "Button 2 - Secondary Button Text")
        
        // Body Labels
        addSection(title: "Body Labels")
        addLabel(GPBody1Label(theme: theme), text: "Body 1 - Regular body text for paragraphs and general content. This is the standard body text used throughout the application.")
        addLabel(GPBodyMedium1Label(theme: theme), text: "Body Medium 1 - Medium weight body text for emphasis within paragraphs.")
        addLabel(GPBody2Label(theme: theme), text: "Body 2 - Larger body text for important content and descriptions.")
        addLabel(GPBodyMedium2Label(theme: theme), text: "Body Medium 2 - Medium weight larger body text for emphasized important content.")
        addLabel(GPBodyCompact1Label(theme: theme), text: "Body Compact 1 - Compact body text for limited space areas.")
    }
    
    private func addSection(title: String) {
        let sectionLabel = UILabel()
        sectionLabel.text = title
        sectionLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        sectionLabel.textColor = theme.colors.textSecondary
        sectionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        contentStackView.addArrangedSubview(sectionLabel)
        
        // Add spacing after section title
        let spacingView = UIView()
        spacingView.translatesAutoresizingMaskIntoConstraints = false
        spacingView.heightAnchor.constraint(equalToConstant: 8).isActive = true
        contentStackView.addArrangedSubview(spacingView)
    }
    
    private func addLabel(_ label: GPBaseLabel, text: String) {
        label.text = text
        label.translatesAutoresizingMaskIntoConstraints = false
        
        // Create container view for proper spacing
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            label.topAnchor.constraint(equalTo: containerView.topAnchor),
            label.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
        
        contentStackView.addArrangedSubview(containerView)
        
        // Add spacing between labels
        let spacingView = UIView()
        spacingView.translatesAutoresizingMaskIntoConstraints = false
        spacingView.heightAnchor.constraint(equalToConstant: 8).isActive = true
        contentStackView.addArrangedSubview(spacingView)
    }
} 
