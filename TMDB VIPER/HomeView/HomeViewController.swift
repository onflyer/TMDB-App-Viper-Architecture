//
//  HomeViewController.swift
//  TMDB VIPER
//
//  Created by Aleksandar Milidrag on 22. 12. 2024..
//

import UIKit

// MARK: - Section Enum
/// Defines the sections in our collection view.
/// SwiftUI equivalent: The different Section blocks in your List
enum HomeSection: Int, CaseIterable {
    case nowPlaying = 0
    case upcoming = 1
    case topRated = 2
    case popular = 3
    
    var title: String {
        switch self {
        case .nowPlaying: return "Now Playing"
        case .upcoming: return "Upcoming"
        case .topRated: return "Top Rated"
        case .popular: return "Popular"
        }
    }
}

// MARK: - HomeViewController
final class HomeViewController: UIViewController {
    
    // MARK: - Properties
    
    private let presenter: HomePresenter
    private var hasLoadedInitialData = false
    private var isSearching = false
    
    // MARK: - UI Elements
    
    /// The main collection view displaying all movie sections.
    /// SwiftUI equivalent: List with multiple Section blocks
    private lazy var collectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        cv.backgroundColor = .systemBackground
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.delegate = self
        cv.dataSource = self
        
        // Register cells and headers
        cv.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: MovieCollectionViewCell.reuseIdentifier)
        cv.register(SectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeaderView.reuseIdentifier)
        
        return cv
    }()
    
    /// Table view for search results.
    /// SwiftUI equivalent: The searchable suggestions section
    private lazy var searchResultsTableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .plain)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.delegate = self
        tv.dataSource = self
        tv.register(SearchResultCell.self, forCellReuseIdentifier: SearchResultCell.reuseIdentifier)
        tv.isHidden = true
        tv.keyboardDismissMode = .onDrag
        return tv
    }()
    
    /// Search controller for movie search.
    /// SwiftUI equivalent: .searchable(text: $presenter.query)
    private lazy var searchController: UISearchController = {
        let sc = UISearchController(searchResultsController: nil)
        sc.searchResultsUpdater = self
        sc.delegate = self
        sc.obscuresBackgroundDuringPresentation = false
        sc.searchBar.placeholder = "Search movies"
        return sc
    }()
    
    /// Loading indicator shown during initial data load.
    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    // MARK: - Initialization
    
    init(presenter: HomePresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
        
        // Wire up the delegate - this is KEY for UIKit
        presenter.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavigationBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Only load data once, not every time view appears
        guard !hasLoadedInitialData else { return }
        hasLoadedInitialData = true
        
        loadAllMovies()
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(collectionView)
        view.addSubview(searchResultsTableView)
        view.addSubview(loadingIndicator)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // Search results table overlays the collection view
            searchResultsTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchResultsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchResultsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            searchResultsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // Loading indicator centered
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
    
    private func setupNavigationBar() {
        title = "Welcome to TMDB"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    // MARK: - Data Loading
    
    private func loadAllMovies() {
        Task {
            await presenter.loadAllMovies()
        }
    }
    
    // MARK: - Error Handling
    
    /// Shows an error alert to the user.
    /// Production apps should inform users when something goes wrong.
    private func showErrorAlert(message: String, retryAction: (() -> Void)? = nil) {
        let alert = UIAlertController(
            title: "Error",
            message: message,
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        
        if let retryAction = retryAction {
            alert.addAction(UIAlertAction(title: "Retry", style: .default) { _ in
                retryAction()
            })
        }
        
        present(alert, animated: true)
    }
    
    // MARK: - Layout Creation
    
    /// Creates the compositional layout for the collection view.
    /// This is the modern way to create complex layouts in UIKit.
    ///
    /// SwiftUI equivalent: The implicit layout from VStack, HStack, ScrollView
    private func createLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { [weak self] sectionIndex, environment in
            guard let section = HomeSection(rawValue: sectionIndex) else { return nil }
            
            switch section {
            case .nowPlaying, .topRated:
                return self?.createPosterSection()
            case .upcoming, .popular:
                return self?.createBackdropSection()
            }
        }
    }
    
    /// Creates a section with poster-style cells (taller, narrower).
    private func createPosterSection() -> NSCollectionLayoutSection {
        // Item
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .absolute(LayoutConstants.Poster.width),
            heightDimension: .absolute(LayoutConstants.Poster.height)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: LayoutConstants.Spacing.medium)
        
        // Group (horizontal)
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .absolute(LayoutConstants.Poster.width),
            heightDimension: .absolute(LayoutConstants.Poster.height)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        // Section
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = NSDirectionalEdgeInsets(
            top: LayoutConstants.Spacing.medium,
            leading: LayoutConstants.Spacing.standard,
            bottom: LayoutConstants.Spacing.standard,
            trailing: LayoutConstants.Spacing.standard
        )
        
        // Header
        section.boundarySupplementaryItems = [createSectionHeader()]
        
        return section
    }
    
    /// Creates a section with backdrop-style cells (wider, shorter).
    private func createBackdropSection() -> NSCollectionLayoutSection {
        // Item
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .absolute(LayoutConstants.Backdrop.width),
            heightDimension: .absolute(LayoutConstants.Backdrop.height)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: LayoutConstants.Spacing.medium)
        
        // Group (horizontal)
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .absolute(LayoutConstants.Backdrop.width),
            heightDimension: .absolute(LayoutConstants.Backdrop.height)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        // Section
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = NSDirectionalEdgeInsets(
            top: LayoutConstants.Spacing.medium,
            leading: LayoutConstants.Spacing.standard,
            bottom: LayoutConstants.Spacing.standard,
            trailing: LayoutConstants.Spacing.standard
        )
        
        // Header
        section.boundarySupplementaryItems = [createSectionHeader()]
        
        return section
    }
    
    private func createSectionHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(LayoutConstants.SectionHeader.height)
        )
        return NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
    }
}

// MARK: - HomePresenterDelegate
/// The presenter notifies the ViewController of data changes via this delegate.
/// This is the UIKit equivalent of SwiftUI's automatic @Observable updates.
extension HomeViewController: HomePresenterDelegate {
    
    func didLoadMovies(for section: HomeSection) {
        // Reload only the affected section for better performance
        collectionView.reloadSections(IndexSet(integer: section.rawValue))
    }
    
    func didFailToLoadMovies(with error: Error) {
        showErrorAlert(message: "Failed to load movies. Please try again.") { [weak self] in
            self?.loadAllMovies()
        }
    }
    
    func didStartLoading() {
        loadingIndicator.startAnimating()
        collectionView.isHidden = true
    }
    
    func didFinishLoading() {
        loadingIndicator.stopAnimating()
        collectionView.isHidden = false
        collectionView.reloadData()
    }
    
    func didLoadSearchResults() {
        searchResultsTableView.reloadData()
    }
    
    func didFailToSearch(with error: Error) {
        showErrorAlert(message: "Search failed. Please try again.")
    }
}

// MARK: - UICollectionViewDataSource
extension HomeViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return HomeSection.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let homeSection = HomeSection(rawValue: section) else { return 0 }
        
        switch homeSection {
        case .nowPlaying: return presenter.nowPlayingMovies.count
        case .upcoming: return presenter.upcomingMovies.count
        case .topRated: return presenter.topRatedMovies.count
        case .popular: return presenter.popularMovies.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: MovieCollectionViewCell.reuseIdentifier,
            for: indexPath
        ) as? MovieCollectionViewCell else {
            // This should never happen if cell is registered correctly
            assertionFailure("Failed to dequeue MovieCollectionViewCell - check cell registration")
            return UICollectionViewCell()
        }
        
        guard let section = HomeSection(rawValue: indexPath.section) else { return cell }
        
        let movie: Movie
        switch section {
        case .nowPlaying:
            movie = presenter.nowPlayingMovies[indexPath.item]
            cell.configure(with: movie, showTitle: false)
        case .upcoming:
            movie = presenter.upcomingMovies[indexPath.item]
            cell.configureWithBackdrop(with: movie)
        case .topRated:
            movie = presenter.topRatedMovies[indexPath.item]
            cell.configure(with: movie, showTitle: false)
        case .popular:
            movie = presenter.popularMovies[indexPath.item]
            cell.configureWithBackdrop(with: movie)
        }
        
        // Pagination: Load more when reaching end
        checkForPagination(section: section, index: indexPath.item)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader,
              let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: SectionHeaderView.reuseIdentifier,
                for: indexPath
              ) as? SectionHeaderView else {
            assertionFailure("Failed to dequeue SectionHeaderView - check registration")
            return UICollectionReusableView()
        }
        
        if let section = HomeSection(rawValue: indexPath.section) {
            header.configure(with: section.title)
        }
        
        return header
    }
    
    // MARK: - Pagination
    
    private func checkForPagination(section: HomeSection, index: Int) {
        Task {
            switch section {
            case .nowPlaying:
                let movies = presenter.nowPlayingMovies
                if index == movies.count - 1, let lastMovie = movies.last {
                    await presenter.loadMoreNowPlayingMovies(currentItem: lastMovie)
                }
            case .upcoming:
                let movies = presenter.upcomingMovies
                if index == movies.count - 1, let lastMovie = movies.last {
                    await presenter.loadMoreUpcomingMovies(currentItem: lastMovie)
                }
            case .topRated:
                let movies = presenter.topRatedMovies
                if index == movies.count - 1, let lastMovie = movies.last {
                    await presenter.loadMoreTopRatedMovies(currentItem: lastMovie)
                }
            case .popular:
                let movies = presenter.popularMovies
                if index == movies.count - 1, let lastMovie = movies.last {
                    await presenter.loadMorePopularMovies(currentItem: lastMovie)
                }
            }
        }
    }
}

// MARK: - UICollectionViewDelegate
extension HomeViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let section = HomeSection(rawValue: indexPath.section) else { return }
        
        let movie: Movie
        switch section {
        case .nowPlaying: movie = presenter.nowPlayingMovies[indexPath.item]
        case .upcoming: movie = presenter.upcomingMovies[indexPath.item]
        case .topRated: movie = presenter.topRatedMovies[indexPath.item]
        case .popular: movie = presenter.popularMovies[indexPath.item]
        }
        
        presenter.onMoviePressed(id: movie.id)
    }
}

// MARK: - UISearchResultsUpdating
extension HomeViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let query = searchController.searchBar.text else { return }
        
        if query.isEmpty {
            Task {
                await presenter.loadSearchedMovies(query: "")
                await MainActor.run {
                    isSearching = false
                    searchResultsTableView.isHidden = true
                    collectionView.isHidden = false
                }
            }
            return
        }
        
        // Show search results table
        isSearching = true
        searchResultsTableView.isHidden = false
        collectionView.isHidden = true
        
        // Debounce search
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(performSearch), object: nil)
        perform(#selector(performSearch), with: nil, afterDelay: 0.3)
    }
    
    @objc private func performSearch() {
        guard let query = searchController.searchBar.text, !query.isEmpty else { return }
        
        Task {
            await presenter.loadSearchedMovies(query: query)
        }
    }
}

// MARK: - UISearchControllerDelegate
extension HomeViewController: UISearchControllerDelegate {
    
    func willDismissSearchController(_ searchController: UISearchController) {
        isSearching = false
        searchResultsTableView.isHidden = true
        collectionView.isHidden = false
    }
}

// MARK: - UITableViewDataSource (Search Results)
extension HomeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.searchedMovies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: SearchResultCell.reuseIdentifier,
            for: indexPath
        ) as? SearchResultCell else {
            assertionFailure("Failed to dequeue SearchResultCell - check registration")
            return UITableViewCell()
        }
        
        let movie = presenter.searchedMovies[indexPath.row]
        cell.configure(with: movie)
        return cell
    }
}

// MARK: - UITableViewDelegate (Search Results)
extension HomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let movie = presenter.searchedMovies[indexPath.row]
        presenter.onMoviePressed(id: movie.id)
        
        // Dismiss search when selecting a result
        searchController.isActive = false
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return LayoutConstants.CellHeight.searchResult
    }
}

// MARK: - SwiftUI vs UIKit Architecture Comparison
/*
 
 ┌─────────────────────────────────────────────────────────────────┐
 │           DATA FLOW COMPARISON                                  │
 ├─────────────────────────────────────────────────────────────────┤
 │                                                                 │
 │   SWIFTUI:                                                      │
 │   ────────                                                      │
 │                                                                 │
 │   User taps "Load" → .task { await presenter.load() }          │
 │                              ↓                                  │
 │   @Observable Presenter updates nowPlayingMovies                │
 │                              ↓                                  │
 │   SwiftUI AUTOMATICALLY re-renders body                        │
 │                              ↓                                  │
 │   ForEach sees new data → new cells appear                     │
 │                                                                 │
 │                                                                 │
 │   UIKIT (with Delegate Pattern):                               │
 │   ──────────────────────────────                               │
 │                                                                 │
 │   User taps "Load" → Task { await presenter.loadAllMovies() }  │
 │                              ↓                                  │
 │   Presenter updates nowPlayingMovies                           │
 │                              ↓                                  │
 │   Presenter calls delegate?.didLoadMovies(for: .nowPlaying)    │
 │                              ↓                                  │
 │   ViewController receives callback, calls reloadData()         │
 │                              ↓                                  │
 │   DataSource methods called → cells created/updated            │
 │                                                                 │
 ├─────────────────────────────────────────────────────────────────┤
 │                                                                 │
 │   THE KEY INSIGHT:                                              │
 │   SwiftUI = Automatic UI updates (reactive)                    │
 │   UIKit = Manual UI updates via delegate (imperative)          │
 │                                                                 │
 │   Both use the SAME presenter with the SAME data!              │
 │                                                                 │
 └─────────────────────────────────────────────────────────────────┘
 
 */
