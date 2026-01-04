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
    
    private lazy var tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .insetGrouped)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.delegate = self
        tv.dataSource = self
        tv.register(UITableViewCell.self, forCellReuseIdentifier: "TrailerCell")
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
        setupNavigationBar()
        checkEmptyState()
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(tableView)
        view.addSubview(emptyLabel)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            emptyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
    
    private func setupNavigationBar() {
        title = "Trailers"
        
        let closeButton = UIBarButtonItem(
            image: UIImage(systemName: "xmark.circle.fill"),
            style: .plain,
            target: self,
            action: #selector(closeTapped)
        )
        closeButton.tintColor = .secondaryLabel
        navigationItem.rightBarButtonItem = closeButton
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
        }
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension TrailerModalViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        // Open YouTube URL
        if let trailer = movie.videos?.results?[indexPath.row],
           let url = trailer.youtubeURL {
            UIApplication.shared.open(url)
        }
    }
}
