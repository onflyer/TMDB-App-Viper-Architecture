//
//  HomeViewController.swift
//  TMDB VIPER
//
//  Created by Aleksandar Milidrag on 22. 12. 2024..
//

import UIKit

// MARK: - HomeViewController
/// The UIKit equivalent of your HomeView.
///
/// Key difference from SwiftUI:
/// - SwiftUI View is a struct, recreated on every state change
/// - UIViewController is a class, lives for the duration of the screen
///
/// We'll flesh this out fully later - this is just a placeholder to get the app running.

class HomeViewController: UIViewController {
    
    // MARK: - Properties
    
    private let presenter: HomePresenter
    
    // MARK: - Initialization
    
    /// In UIKit, we use initializers instead of SwiftUI's property injection
    ///
    /// SwiftUI:  HomeView(presenter: presenter, delegate: delegate)
    /// UIKit:    HomeViewController(presenter: presenter)
    init(presenter: HomePresenter) {
        self.presenter = presenter
        // Must call super.init with nibName/bundle for UIViewController
        super.init(nibName: nil, bundle: nil)
    }
    
    /// Required by iOS - we don't use storyboards so this will never be called
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented - we don't use storyboards")
    }
    
    // MARK: - Lifecycle
    
    /// Called when the view is loaded into memory.
    /// SwiftUI equivalent: The initial setup in your View's body
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    /// Called when the view is about to appear.
    /// SwiftUI equivalent: .onAppear { }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    /// Called when the view has appeared.
    /// SwiftUI equivalent: Also .onAppear { } (SwiftUI doesn't distinguish will/did)
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Load data when view appears
        // In SwiftUI you used .task { await presenter.loadNowPlayingMovies() }
        Task {
            await presenter.loadNowPlayingMovies()
        }
    }
    
    /// Called when the view is about to disappear.
    /// SwiftUI equivalent: .onDisappear { }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        // Set background color so we can see something
        view.backgroundColor = .systemBackground
        
        // Set navigation title
        // SwiftUI equivalent: .navigationTitle("Welcome to TMDB")
        title = "Welcome to TMDB"
        
        // Placeholder label - we'll replace with UICollectionView/UITableView later
        let label = UILabel()
        label.text = "🎬 HomeViewController is working!\n\nWe'll add the full UI next."
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(label)
        
        // AutoLayout constraints
        // SwiftUI equivalent: .frame(maxWidth: .infinity, maxHeight: .infinity)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
}

// MARK: - SwiftUI vs UIKit Lifecycle Comparison
/*
 
 ┌─────────────────────────────────────────────────────────────────┐
 │                    LIFECYCLE METHODS                            │
 ├─────────────────────────────────────────────────────────────────┤
 │                                                                 │
 │   SwiftUI                      UIKit                           │
 │   ────────                     ─────                           │
 │                                                                 │
 │   (implicit)                   viewDidLoad()                   │
 │                                ← Called once when VC loads     │
 │                                                                 │
 │   .onAppear { }                viewWillAppear(_:)              │
 │                                viewDidAppear(_:)               │
 │                                ← Called every time view shows  │
 │                                                                 │
 │   .onDisappear { }             viewWillDisappear(_:)           │
 │                                viewDidDisappear(_:)            │
 │                                ← Called every time view hides  │
 │                                                                 │
 │   .task { }                    Task { } in viewDidAppear       │
 │                                ← For async work                │
 │                                                                 │
 └─────────────────────────────────────────────────────────────────┘
 
 */
