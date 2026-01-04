//
//  ImageModalViewController.swift
//  TMDB VIPER
//
//  Created by Aleksandar Milidrag on 22. 12. 2024..
//

import UIKit
import SDWebImage

// MARK: - ImageModalViewController
/// The UIKit equivalent of your ImageModalView.
///
/// SwiftUI version shows a fullscreen image in a modal overlay.
/// UIKit version uses a presented view controller with UIImageView.
///
/// COMPARISON:
/// ┌─────────────────────────────────────────────────────────────┐
/// │  SwiftUI                    │  UIKit                        │
/// ├─────────────────────────────────────────────────────────────┤
/// │  ImageLoaderView(url)       │  UIImageView + SDWebImage     │
/// │  .scaledToFit()             │  contentMode = .scaleAspectFit│
/// │  ZStack { }                 │  view.addSubview()            │
/// │  background(.black.opacity) │  backgroundColor = .black     │
/// │  onTapGesture { dismiss }   │  UITapGestureRecognizer       │
/// └─────────────────────────────────────────────────────────────┘

class ImageModalViewController: UIViewController {
    
    // MARK: - Properties
    
    private let imageURLString: String
    private let onDismiss: () -> Void
    
    // MARK: - UI Elements
    
    private lazy var imageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        return iv
    }()
    
    private lazy var closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        let config = UIImage.SymbolConfiguration(pointSize: 28, weight: .medium)
        button.setImage(UIImage(systemName: "xmark.circle.fill", withConfiguration: config), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.color = .white
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    // MARK: - Initialization
    
    init(imageURLString: String, onDismiss: @escaping () -> Void) {
        self.imageURLString = imageURLString
        self.onDismiss = onDismiss
        super.init(nibName: nil, bundle: nil)
        
        // Present as fullscreen with transparent background for overlay effect
        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .crossDissolve
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadImage()
        setupGestures()
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        // Dark semi-transparent background (like SwiftUI's .black.opacity(0.7))
        view.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        
        view.addSubview(imageView)
        view.addSubview(closeButton)
        view.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            // Image fills most of the screen with padding
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageView.heightAnchor.constraint(lessThanOrEqualTo: view.heightAnchor, multiplier: 0.8),
            
            // Close button in top right
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            closeButton.widthAnchor.constraint(equalToConstant: 44),
            closeButton.heightAnchor.constraint(equalToConstant: 44),
            
            // Activity indicator centered
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
    
    private func loadImage() {
        guard let url = URL(string: imageURLString) else { return }
        
        activityIndicator.startAnimating()
        
        // SDWebImage handles async loading and caching
        imageView.sd_setImage(with: url) { [weak self] _, _, _, _ in
            self?.activityIndicator.stopAnimating()
        }
    }
    
    private func setupGestures() {
        // Tap anywhere to dismiss (like SwiftUI's onTapGesture on background)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backgroundTapped))
        view.addGestureRecognizer(tapGesture)
        
        // Don't dismiss when tapping on image itself
        imageView.isUserInteractionEnabled = true
        let imageTap = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        imageView.addGestureRecognizer(imageTap)
    }
    
    // MARK: - Actions
    
    @objc private func closeTapped() {
        dismissModal()
    }
    
    @objc private func backgroundTapped() {
        dismissModal()
    }
    
    @objc private func imageTapped() {
        // Do nothing - prevents background tap from triggering
    }
    
    private func dismissModal() {
        dismiss(animated: true) {
            self.onDismiss()
        }
    }
}
