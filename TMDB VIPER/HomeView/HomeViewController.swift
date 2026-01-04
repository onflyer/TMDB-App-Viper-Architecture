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

// MARK: - HomePresenterDelegate
/// Protocol for presenter to communicate UI updates back to the view controller.
///
/// This is the KEY DIFFERENCE from SwiftUI:
/// - SwiftUI: @Observable automatically triggers body recomputation
/// - UIKit: Presenter calls these delegate methods, VC manually updates UI
protocol HomePresenterDelegate: AnyObject {
    func didLoadMovies(for section: HomeSection)
    func didFailToLoadMovies(with error: Error)
}

// MARK: - HomeViewController
class HomeViewController: UIViewController {
    
    // MARK: - Properties
    
    private let presenter: HomePresenter
    var builder: CoreBuilder?
    private var hasLoadedInitialData = false  // Prevent reloading on every viewDidAppear
    private var isSearching = false  // Track search state
    
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
        tv.isHidden = true  // Hidden by default
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
    
    // MARK: - Initialization
    
    init(presenter: HomePresenter) {
        self.presenter = presenter
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
            // Load all sections concurrently
            async let nowPlaying: () = presenter.loadNowPlayingMovies()
            async let upcoming: () = presenter.loadUpcomingMovies()
            async let topRated: () = presenter.loadTopRatedMovies()
            async let popular: () = presenter.loadPopularMovies()
            
            // Wait for all to complete
            _ = await (nowPlaying, upcoming, topRated, popular)
            
            // Single reload after all data is loaded
            await MainActor.run {
                collectionView.reloadData()
            }
        }
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
    /// SwiftUI equivalent:
    /// ```
    /// ScrollView(.horizontal) {
    ///     LazyHStack {
    ///         ForEach(movies) { MovieCellView(...).frame(width: 150, height: 225) }
    ///     }
    /// }
    /// ```
    private func createPosterSection() -> NSCollectionLayoutSection {
        // Item
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .absolute(150),
            heightDimension: .absolute(225)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 8)
        
        // Group (horizontal)
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .absolute(150),
            heightDimension: .absolute(225)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        // Section
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous  // Horizontal scroll!
        section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 16, bottom: 16, trailing: 16)
        
        // Header
        section.boundarySupplementaryItems = [createSectionHeader()]
        
        return section
    }
    
    /// Creates a section with backdrop-style cells (wider, shorter).
    /// SwiftUI equivalent: Your upcoming/popular sections with .frame(width: 300, height: 170)
    private func createBackdropSection() -> NSCollectionLayoutSection {
        // Item
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .absolute(300),
            heightDimension: .absolute(170)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 8)
        
        // Group (horizontal)
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .absolute(300),
            heightDimension: .absolute(170)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        // Section
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 16, bottom: 16, trailing: 16)
        
        // Header
        section.boundarySupplementaryItems = [createSectionHeader()]
        
        return section
    }
    
    private func createSectionHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(44)
        )
        return NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
    }
}

// MARK: - UICollectionViewDataSource
/// Provides data to the collection view.
/// SwiftUI equivalent: ForEach(presenter.nowPlayingMovies) { movie in ... }
extension HomeViewController: UICollectionViewDataSource {
    
    /// Number of sections
    /// SwiftUI equivalent: Number of Section blocks in List
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return HomeSection.allCases.count
    }
    
    /// Number of items in each section
    /// SwiftUI equivalent: movies.count in ForEach
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let homeSection = HomeSection(rawValue: section) else { return 0 }
        
        switch homeSection {
        case .nowPlaying: return presenter.nowPlayingMovies.count
        case .upcoming: return presenter.upcomingMovies.count
        case .topRated: return presenter.topRatedMovies.count
        case .popular: return presenter.popularMovies.count
        }
    }
    
    /// Creates/configures a cell for each item.
    /// SwiftUI equivalent: The view returned inside ForEach { movie in MovieCellView(...) }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: MovieCollectionViewCell.reuseIdentifier,
            for: indexPath
        ) as? MovieCollectionViewCell else {
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
        // SwiftUI equivalent: .task { await presenter.loadMoreNowPlayingMovies(currentItem: movie) }
        checkForPagination(section: section, index: indexPath.item)
        
        return cell
    }
    
    /// Creates/configures section headers.
    /// SwiftUI equivalent: Section { } header: { Text("Now Playing") }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader,
              let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: SectionHeaderView.reuseIdentifier,
                for: indexPath
              ) as? SectionHeaderView else {
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
                    await MainActor.run {
                        collectionView.reloadData()
                    }
                }
            case .upcoming:
                let movies = presenter.upcomingMovies
                if index == movies.count - 1, let lastMovie = movies.last {
                    await presenter.loadMoreUpcomingMovies(currentItem: lastMovie)
                    await MainActor.run {
                        collectionView.reloadData()
                    }
                }
            case .topRated:
                let movies = presenter.topRatedMovies
                if index == movies.count - 1, let lastMovie = movies.last {
                    await presenter.loadMoreTopRatedMovies(currentItem: lastMovie)
                    await MainActor.run {
                        collectionView.reloadData()
                    }
                }
            case .popular:
                let movies = presenter.popularMovies
                if index == movies.count - 1, let lastMovie = movies.last {
                    await presenter.loadMorePopularMovies(currentItem: lastMovie)
                    await MainActor.run {
                        collectionView.reloadData()
                    }
                }
            }
        }
    }
}

// MARK: - UICollectionViewDelegate
/// Handles user interactions with the collection view.
extension HomeViewController: UICollectionViewDelegate {
    
    /// Called when user taps a cell.
    /// SwiftUI equivalent: .onTapGesture { } or Button action
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let section = HomeSection(rawValue: indexPath.section) else { return }
        
        let movie: Movie
        switch section {
        case .nowPlaying: movie = presenter.nowPlayingMovies[indexPath.item]
        case .upcoming: movie = presenter.upcomingMovies[indexPath.item]
        case .topRated: movie = presenter.topRatedMovies[indexPath.item]
        case .popular: movie = presenter.popularMovies[indexPath.item]
        }
        
        // Navigate using presenter (same as SwiftUI!)
        presenter.onMoviePressed(id: movie.id)
    }
}

// MARK: - UISearchResultsUpdating
/// Handles search text changes.
/// SwiftUI equivalent: .searchable(text: $presenter.query) + .task(id: presenter.query)
extension HomeViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let query = searchController.searchBar.text else { return }
        
        if query.isEmpty {
            // Clear search results and hide table
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
        
        // Debounce search - wait for user to stop typing
        // SwiftUI does this automatically with .task(id:)
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(performSearch), object: nil)
        perform(#selector(performSearch), with: nil, afterDelay: 0.3)
    }
    
    @objc private func performSearch() {
        guard let query = searchController.searchBar.text, !query.isEmpty else { return }
        
        Task {
            await presenter.loadSearchedMovies(query: query)
            await MainActor.run {
                searchResultsTableView.reloadData()
            }
        }
    }
}

// MARK: - UISearchControllerDelegate
extension HomeViewController: UISearchControllerDelegate {
    
    func willDismissSearchController(_ searchController: UISearchController) {
        // When search is cancelled, show collection view again
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
        return 100
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
 │   UIKIT:                                                        │
 │   ──────                                                        │
 │                                                                 │
 │   User taps "Load" → Task { await presenter.load() }           │
 │                              ↓                                  │
 │   Presenter updates nowPlayingMovies                           │
 │                              ↓                                  │
 │   ⚠️ NOTHING HAPPENS AUTOMATICALLY ⚠️                          │
 │                              ↓                                  │
 │   YOU must call: collectionView.reloadData()                   │
 │                              ↓                                  │
 │   DataSource methods called → cells created/updated            │
 │                                                                 │
 ├─────────────────────────────────────────────────────────────────┤
 │                                                                 │
 │   THE KEY INSIGHT:                                              │
 │   SwiftUI = Automatic UI updates (reactive)                    │
 │   UIKit = Manual UI updates (imperative)                       │
 │                                                                 │
 │   Both use the SAME presenter with the SAME data!              │
 │                                                                 │
 └─────────────────────────────────────────────────────────────────┘
 
 */
