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
    let theme: GPTheme
    let selectedOption: DropdownOption?
    var onSelect: ((DropdownOption) -> Void)?
    
    private let tableView = UITableView()
    private let navBar = UIView()
    private let closeButton = UIButton(type: .system)
    
    init(
        options: [DropdownOption],
        selectedOption: DropdownOption? = nil,
        navBarTitle: String,
        theme: GPTheme
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
        setupTableView()
    }
    
    // MARK: - Setup UI
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
        barStack.spacing = theme.appearance.rowSpacing
        barStack.translatesAutoresizingMaskIntoConstraints = false
        
        navBar.backgroundColor = theme.colors.bgDefaultLight
        navBar.translatesAutoresizingMaskIntoConstraints = false
        navBar.addSubview(barStack)
        view.addSubview(navBar)
        
        NSLayoutConstraint.activate([
            barStack.leadingAnchor.constraint(equalTo: navBar.leadingAnchor, constant: theme.appearance.padding),
            barStack.trailingAnchor.constraint(equalTo: navBar.trailingAnchor, constant: -theme.appearance.padding),
            barStack.centerYAnchor.constraint(equalTo: navBar.centerYAnchor),
            navBar.topAnchor.constraint(equalTo: view.topAnchor, constant: theme.appearance.padding),
            navBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            navBar.heightAnchor.constraint(equalToConstant: 48),
        ])
    }
    
    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(DropdownIconTextCell.self, forCellReuseIdentifier: "DropdownIconTextCell")
        tableView.register(DropdownPhoneOptionCell.self, forCellReuseIdentifier: "DropdownPhoneOptionCell")

        view.addSubview(tableView)
        
        let estimatedCellHeight: CGFloat = 64
        let navBarHeight: CGFloat = 48
        let totalSpacing: CGFloat = theme.appearance.padding + view.safeAreaInsets.bottom
        
        let estimatedTableViewHeight = CGFloat(options.count) * estimatedCellHeight
        let safeAreaHeight = view.safeAreaLayoutGuide.layoutFrame.height

        // Calculate max allowable table height based on safe area
        let maxAllowedTableViewHeight = safeAreaHeight - navBarHeight - totalSpacing

        // Use the smaller value between estimated height and max allowed
        let finalTableViewHeight = min(estimatedTableViewHeight, maxAllowedTableViewHeight)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: navBar.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.heightAnchor.constraint(equalToConstant: finalTableViewHeight)
        ])
        
        // Scroll to selected cell
        if let selectedOption = selectedOption,
           let index = options.firstIndex(where: { $0.value == selectedOption.value }) {
            let indexPath = IndexPath(row: index, section: 0)
            DispatchQueue.main.async {
                self.tableView.scrollToRow(at: indexPath, at: .middle, animated: false)
            }
        }
    }
    
    @objc private func dismissSheet() {
        dismiss(animated: true)
    }
}

extension DropdownSheetViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let option = options[indexPath.row]
        
        if let option = option as? DropdownPhoneOption {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DropdownPhoneOptionCell", for: indexPath) as! DropdownPhoneOptionCell
            cell.configure(with: option, theme: theme)
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DropdownIconTextCell", for: indexPath) as! DropdownIconTextCell
        let isSelectedCell = option.value == selectedOption?.value
        cell.configure(with: option, theme: theme, isSelected: isSelectedCell)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        onSelect?(options[indexPath.row])
        dismissSheet()
    }
}

extension DropdownSheetViewController: BottomSheetPresentable {
    func didTapOrSwipeToDismiss() {
        dismissSheet()
    }
}
