import UIKit

/// This is an abstract class
open class GPBaseButton: UIView {
    public enum State {
        case active, loading, success, inactive
    }
    
    // MARK: - UI Elements
    lazy var imvIcon: UIImageView = {
        let ic = UIImageView()
        ic.isUserInteractionEnabled = false
        ic.setSize(.init(width: 24, height: 24))
        ic.contentMode = .scaleAspectFit
        return ic
    }()
    lazy var lblTitle: UILabel = {
        let lbl = UILabel()
        lbl.isUserInteractionEnabled = false
        return lbl
    }()
    private lazy var primaryView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [imvIcon, lblTitle])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 8
        stackView.distribution = .fill
        stackView.isUserInteractionEnabled = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    private lazy var loadingView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.isUserInteractionEnabled = false
        NSLayoutConstraint.activate([image.widthAnchor.constraint(equalToConstant: 24),
                                     image.heightAnchor.constraint(equalToConstant: 24)])
        return image
    }()
    private lazy var successView: UIImageView = {
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
    private var onTap: (() -> Void)?
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
        // constraint subviews
        addSubview(primaryView)
        addSubview(loadingView)
        addSubview(successView)
        NSLayoutConstraint.activate([
            primaryView.centerXAnchor.constraint(equalTo: centerXAnchor),
            primaryView.centerYAnchor.constraint(equalTo: centerYAnchor),
            primaryView.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor),
            primaryView.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor),
            primaryView.topAnchor.constraint(greaterThanOrEqualTo: topAnchor),
            primaryView.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor),
        ])
        NSLayoutConstraint.activate([
            loadingView.centerXAnchor.constraint(equalTo: centerXAnchor),
            loadingView.centerYAnchor.constraint(equalTo: centerYAnchor),
            loadingView.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor),
            loadingView.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor),
            loadingView.topAnchor.constraint(greaterThanOrEqualTo: topAnchor),
            loadingView.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor),
        ])
        NSLayoutConstraint.activate([
            successView.centerXAnchor.constraint(equalTo: centerXAnchor),
            successView.centerYAnchor.constraint(equalTo: centerYAnchor),
            successView.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor),
            successView.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor),
            successView.topAnchor.constraint(greaterThanOrEqualTo: topAnchor),
            successView.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor),
        ])
        
        // register tap behavior
        let tap = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        tap.minimumPressDuration = 0
        addGestureRecognizer(tap)
        
        // set up views
        if let height = getHeight() {
            nsHeight.constant = height
            nsHeight.isActive = true
        } else {
            nsHeight.isActive = false
        }
        if let icLoading = createLoadingImage() {
            loadingView.image = icLoading
        }
        if let icSuccess = createSuccessImage() {
            successView.image = icSuccess
        }
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
    
    public func config(title: String? = nil, icon: UIImage? = nil, onTap: (() -> Void)? = nil) {
        self.onTap = onTap
        setIcon(icon)
        setTitle(title)
        setState(state)
    }
    
    public func setState(_ state: State) {
        self.state = state
        primaryView.isHidden = true
        loadingView.isHidden = true
        successView.isHidden = true
        isUserInteractionEnabled = false
        setLoadingState(false)
        
        switch state {
        case .active:
            primaryView.isHidden = false
            isUserInteractionEnabled = true
        case .inactive:
            primaryView.isHidden = false
        case .loading:
            setLoadingState(true)
        case .success:
            successView.isHidden = false
        }
        doStyle(for: state)
    }
    
    public func setTitle(_ title: String?) {
        if let title {
            lblTitle.isHidden = false
            lblTitle.text = title
        } else {
            lblTitle.isHidden = true
        }
    }
    
    public func setIcon(_ icon: UIImage?) {
        if let icon {
            imvIcon.isHidden = false
            imvIcon.image = icon
        } else {
            imvIcon.isHidden = true
        }
    }
    
    private func setLoadingState(_ isLoading: Bool) {
        loadingView.isHidden = !isLoading
        if isLoading {
            // Apply a rotation animation
            let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
            rotationAnimation.toValue = NSNumber(value: Double.pi * 2)
            rotationAnimation.duration = 0.8
            rotationAnimation.isCumulative = true
            rotationAnimation.repeatCount = .infinity
            loadingView.layer.add(rotationAnimation, forKey: "rotationAnimation")
        } else {
            loadingView.layer.removeAllAnimations()
        }
    }
    
    /// Child class must override this function to set style for states
    func doStyle(for state: State) {
        fatalError("Child class must implement this function")
    }
    
    /// Child class can override this function to provide loading image
    func createLoadingImage() -> UIImage? {
        return nil
    }
    
    /// Child class can override this function to provide success image
    func createSuccessImage() -> UIImage? {
        return nil
    }
    
    /// Child class can override this function to provide height of button
    func getHeight() -> CGFloat? {
        return nil
    }
}

