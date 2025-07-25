import UIKit

// MARK: - GPBaseButton
open class GPBaseButton: UIView {
    public enum State {
        case active, loading, success, inactive
    }
    
    // MARK: - UI Elements
    private lazy var icLeading: UIImageView = {
        let ic = UIImageView()
        ic.isUserInteractionEnabled = false
        return ic
    }()
    lazy var lblTitle: UILabel = {
        let lbl = UILabel()
        lbl.isUserInteractionEnabled = false
        return lbl
    }()
    private lazy var primaryView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [icLeading, lblTitle])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 8
        stackView.distribution = .fill
        stackView.isUserInteractionEnabled = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    private lazy var secondaryView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.isUserInteractionEnabled = false
        NSLayoutConstraint.activate([image.widthAnchor.constraint(equalToConstant: 24),
                                     image.heightAnchor.constraint(equalToConstant: 24)])
        return image
    }()
    private lazy var nsHeight: NSLayoutConstraint = {
        translatesAutoresizingMaskIntoConstraints = false
        return heightAnchor.constraint(greaterThanOrEqualToConstant: 54)
    }()
    
    // MARK: - Properties
    var icon: UIImage?
    var title: String?
    var icLoading: UIImage?
    var icSuccess: UIImage?
    var onTap: (() -> Void)?
    var state: State = .active
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        addSubview(primaryView)
        addSubview(secondaryView)
        NSLayoutConstraint.activate([
            primaryView.centerXAnchor.constraint(equalTo: centerXAnchor),
            primaryView.centerYAnchor.constraint(equalTo: centerYAnchor),
            primaryView.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor),
            primaryView.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor),
            primaryView.topAnchor.constraint(greaterThanOrEqualTo: topAnchor),
            primaryView.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor),
        ])
        NSLayoutConstraint.activate([
            secondaryView.centerXAnchor.constraint(equalTo: centerXAnchor),
            secondaryView.centerYAnchor.constraint(equalTo: centerYAnchor),
            secondaryView.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor),
            secondaryView.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor),
            secondaryView.topAnchor.constraint(greaterThanOrEqualTo: topAnchor),
            secondaryView.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor),
        ])
        let tap = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        tap.minimumPressDuration = 0
        addGestureRecognizer(tap)
    }
    
    internal func setup(
        title: String? = nil,
        icon: UIImage? = nil,
        icLoading: UIImage? = nil,
        icSuccess: UIImage? = nil,
        height: CGFloat? = nil,
        onTap: (() -> Void)? = nil
    ) {
        self.icon = icon
        self.title = title
        self.icLoading = icLoading
        self.icSuccess = icSuccess
        self.onTap = onTap
        if let height {
            nsHeight.constant = height
            nsHeight.isActive = true
        } else {
            nsHeight.isActive = false
        }
        if let icon {
            icLeading.image = icon
        }
        if let title {
            lblTitle.text = title
        }
        setState(state)
    }
    
    internal func setState(_ state: State) {
        self.state = state
        switch state {
        case .active, .inactive:
            primaryView.isHidden = false
            secondaryView.isHidden = true
        case .loading:
            primaryView.isHidden = true
            secondaryView.isHidden = false
            if let icLoading {
                secondaryView.image = icLoading
            }
        case .success:
            primaryView.isHidden = true
            secondaryView.isHidden = false
            if let icSuccess {
                secondaryView.image = icSuccess
            }
        }
        doStyle(for: state)
    }
    
    /// Child class must override this function to set style for states
    func doStyle(for state: State) {
        fatalError("Child class must implement this function")
    }
    
    @objc private func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
        guard isUserInteractionEnabled else { return }
        switch gesture.state {
        case .began, .changed:
            self.alpha = 0.6
        case .ended:
            self.alpha = 1.0
            onTap?()
        case .cancelled, .failed:
            self.alpha = 1.0
        default:
            break
        }
    }
}

