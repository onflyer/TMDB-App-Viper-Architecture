//
//  TrailerModalViewController.swift
//  TMDB VIPER
//
//  Created by Aleksandar Milidrag on 22. 12. 2024..
//

import UIKit

// MARK: - TrailerModalViewController
/// The UIKit equivalent of your TrailersModalView.
///
/// SwiftUI version uses a modal overlay with a List of trailers.
/// UIKit version uses a presented sheet with UITableView.

class TrailerModalViewController: UIViewController {
    
    // MARK: - Properties
    
    private let movie: SingleMovie
    private let onDismiss: () -> Void
    
    // MARK: - UI Elements
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Trailers"
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var closeButton: UIButton = {
        let button = UIButton(type: .system)
        let config = UIImage.SymbolConfiguration(pointSize: 24, weight: .medium)
        button.setImage(UIImage(systemName: "xmark.circle.fill", withConfiguration: config), for: .normal)
        button.tintColor = .secondaryLabel
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .plain)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.delegate = self
        tv.dataSource = self
        tv.register(UITableViewCell.self, forCellReuseIdentifier: "TrailerCell")
        tv.backgroundColor = .clear
        tv.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        return tv
    }()
    
    private lazy var emptyLabel: UILabel = {
        let label = UILabel()
        label.text = "No trailers available"
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true
        return label
    }()
    
    // MARK: - Initialization
    
    init(movie: SingleMovie, onDismiss: @escaping () -> Void) {
        self.movie = movie
        self.onDismiss = onDismiss
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupGestures()
        checkEmptyState()
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        // Semi-transparent background
        view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        
        view.addSubview(containerView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(closeButton)
        containerView.addSubview(tableView)
        containerView.addSubview(emptyLabel)
        
        NSLayoutConstraint.activate([
            // Container - centered card
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            containerView.heightAnchor.constraint(lessThanOrEqualTo: view.heightAnchor, multiplier: 0.6),
            
            // Title
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            
            // Close button
            closeButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            closeButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            closeButton.widthAnchor.constraint(equalToConstant: 44),
            closeButton.heightAnchor.constraint(equalToConstant: 44),
            
            // Table view
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            tableView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            tableView.heightAnchor.constraint(greaterThanOrEqualToConstant: 200),
            
            // Empty label
            emptyLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            emptyLabel.centerYAnchor.constraint(equalTo: tableView.centerYAnchor),
        ])
    }
    
    private func setupGestures() {
        // Tap background to dismiss
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backgroundTapped))
        tapGesture.delegate = self
        view.addGestureRecognizer(tapGesture)
    }
    
    private func checkEmptyState() {
        let hasTrailers = !(movie.videos?.results?.isEmpty ?? true)
        emptyLabel.isHidden = hasTrailers
        tableView.isHidden = !hasTrailers
    }
    
    // MARK: - Actions
    
    @objc private func closeTapped() {
        dismiss(animated: true) {
            self.onDismiss()
        }
    }
    
    @objc private func backgroundTapped() {
        closeTapped()
    }
}

// MARK: - UIGestureRecognizerDelegate
extension TrailerModalViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        // Only dismiss if tapping outside the container
        return !containerView.frame.contains(touch.location(in: view))
    }
}

// MARK: - UITableViewDataSource
extension TrailerModalViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movie.videos?.results?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TrailerCell", for: indexPath)
        
        if let trailer = movie.videos?.results?[indexPath.row] {
            var content = cell.defaultContentConfiguration()
            content.text = trailer.name ?? "Trailer"
            content.image = UIImage(systemName: "play.circle.fill")
            content.imageProperties.tintColor = .systemBlue
            cell.contentConfiguration = content
            cell.accessoryType = .disclosureIndicator
            cell.backgroundColor = .clear
        }
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension TrailerModalViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let trailer = movie.videos?.results?[indexPath.row],
           let url = trailer.youtubeURL {
            UIApplication.shared.open(url)
        }
    }
}
