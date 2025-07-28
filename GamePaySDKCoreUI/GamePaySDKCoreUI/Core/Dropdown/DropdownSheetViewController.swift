//
//  DropdownSheetViewController.swift
//  GamePaySDKCoreUI
//
//  Created by Luke Nguyen on 25/7/25.
//

import UIKit

class DropdownSheetViewController: UIViewController {
    // MARK: - Properties
    let options: [DropdownOption]
    private var filteredOptions: [DropdownOption] = []
    let navBarTitle: String
    let theme: GPTheme
    private let hasSearchOption: Bool
    let selectedOption: DropdownOption?
    private let estimatedCellHeight: CGFloat = 64
    private let navBarHeight: CGFloat = 48
    
    // MARK: - Subviews
    private let navBar = UIView()
    private let closeButton = UIButton(type: .system)
    private let tableView = UITableView()
    private lazy var searchTextField = SearchTextField(theme: theme)
    
    // MARK: - Public Properties
    var onSelect: ((DropdownOption) -> Void)?
    
    init(
        options: [DropdownOption],
        selectedOption: DropdownOption? = nil,
        navBarTitle: String,
        hasSearchOption: Bool = false,
        theme: GPTheme
    ) {
        self.options = options
        self.filteredOptions = options
        self.selectedOption = selectedOption
        self.navBarTitle = navBarTitle
        self.hasSearchOption = hasSearchOption
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
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        setupNavBar()
        setupTableView()
    }
    
    private func setupNavBar() {
        let titleLabel = UILabel()
        titleLabel.text = navBarTitle
        titleLabel.font = theme.typography.bodyMedium1
        titleLabel.numberOfLines = 0
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.setContentHuggingPriority(.required, for: .vertical)
        titleLabel.setContentCompressionResistancePriority(.required, for: .vertical)

        closeButton.setImage(GPAssets.icCloseNavBar.image, for: .normal)
        closeButton.tintColor = .label
        closeButton.addTarget(self, action: #selector(dismissSheet), for: .touchUpInside)
        closeButton.translatesAutoresizingMaskIntoConstraints = false

        navBar.backgroundColor = theme.colors.bgDefaultLight
        navBar.translatesAutoresizingMaskIntoConstraints = false

        navBar.addSubview(titleLabel)
        navBar.addSubview(closeButton)
        view.addSubview(navBar)
 
        NSLayoutConstraint.activate([
            navBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: theme.appearance.padding),
            navBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: theme.appearance.padding),
            navBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -theme.appearance.padding),

            closeButton.topAnchor.constraint(equalTo: navBar.topAnchor),
            closeButton.trailingAnchor.constraint(equalTo: navBar.trailingAnchor),
            closeButton.widthAnchor.constraint(equalToConstant: 32),
            closeButton.heightAnchor.constraint(equalToConstant: 32),

            titleLabel.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: navBar.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: navBar.trailingAnchor),
        ])

        if hasSearchOption {
            searchTextField.translatesAutoresizingMaskIntoConstraints = false
            searchTextField.onTextChanged = { [weak self] text in
                self?.filterContent(for: text)
            }
            navBar.addSubview(searchTextField)

            NSLayoutConstraint.activate([
                searchTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: theme.appearance.padding),
                searchTextField.leadingAnchor.constraint(equalTo: navBar.leadingAnchor),
                searchTextField.trailingAnchor.constraint(equalTo: navBar.trailingAnchor),
                searchTextField.bottomAnchor.constraint(equalTo: navBar.bottomAnchor)
            ])
        } else {
            NSLayoutConstraint.activate([
                titleLabel.bottomAnchor.constraint(equalTo: navBar.bottomAnchor)
            ])
        }
        
        view.layoutIfNeeded()
    }

    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = estimatedCellHeight
        tableView.keyboardDismissMode = .onDrag
        tableView.register(DropdownOptionCell.self, forCellReuseIdentifier: "DropdownOptionCell")
        view.addSubview(tableView)
        
        // Calculate final height
        let estimatedTableViewHeight = CGFloat(options.count) * estimatedCellHeight
        let totalSpacing = theme.appearance.padding * 2
        let heightCalculated = estimatedTableViewHeight + navBar.bounds.height + totalSpacing
        let maxAllowedHeight = view.safeAreaLayoutGuide.layoutFrame.height
        let finalHeight = min(heightCalculated, maxAllowedHeight)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: navBar.bottomAnchor, constant: theme.appearance.padding),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            view.heightAnchor.constraint(equalToConstant: finalHeight)
        ])
        
        scrollToSelectedOptionIfNeeded()
    }
    
    private func scrollToSelectedOptionIfNeeded() {
        guard let selectedOption = selectedOption,
              let index = options.firstIndex(where: { $0.value == selectedOption.value }) else { return }
        
        let indexPath = IndexPath(row: index, section: 0)
        DispatchQueue.main.async {
            self.tableView.scrollToRow(at: indexPath, at: .middle, animated: false)
        }
    }
    
    private func filterContent(for query: String) {
        if query.isEmpty {
            filteredOptions = options
        } else {
            filteredOptions = options.filter { $0.name.localizedCaseInsensitiveContains(query) }
        }
        tableView.reloadData()
    }
    
    @objc private func dismissSheet() {
        dismiss(animated: true)
    }
}

extension DropdownSheetViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let option = filteredOptions[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "DropdownOptionCell", for: indexPath) as! DropdownOptionCell
        
        if let option = option as? DropdownPhoneOption {
            cell.configure(with: option, theme: theme)
            return cell
        }
        
        let isSelectedCell = option.value == selectedOption?.value
        cell.configure(with: option, theme: theme, isSelected: isSelectedCell)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        onSelect?(filteredOptions[indexPath.row])
        dismissSheet()
    }
}

extension DropdownSheetViewController: BottomSheetPresentable {
    func didTapOrSwipeToDismiss() {
        dismissSheet()
    }
}
