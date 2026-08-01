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

// MARK: - Diffable Item
/// Snapshot item identifier. The same movie can legitimately appear in more
/// than one section (e.g. both Popular and Top Rated), and diffable
/// identifiers must be unique across the WHOLE snapshot — so identity is
/// (section, movie.id), not the movie alone.
struct HomeItem: Hashable {
    let section: HomeSection
    let movie: Movie

    static func == (lhs: HomeItem, rhs: HomeItem) -> Bool {
        lhs.section == rhs.section && lhs.movie.id == rhs.movie.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(section)
        hasher.combine(movie.id)
    }
}

// MARK: - HomeViewController
final class HomeViewController: UIViewController {

    // MARK: - Properties

    private let presenter: HomePresenter
    private var hasLoadedInitialData = false
    /// Sections with a page request in flight — prevents double-appending a
    /// page when scrolling fast (willDisplay can fire repeatedly at the end).
    private var paginatingSections: Set<HomeSection> = []
    /// Debounced search task — cancelled and recreated on every keystroke.
    private var searchTask: Task<Void, Never>?

    // MARK: - UI Elements

    /// The main collection view displaying all movie sections.
    /// SwiftUI equivalent: List with multiple Section blocks
    private lazy var collectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        cv.backgroundColor = .systemBackground
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.delegate = self
        return cv
    }()

    /// Table view for search results.
    /// SwiftUI equivalent: The searchable suggestions section
    private lazy var searchResultsTableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .plain)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.delegate = self
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
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        return indicator
    }()

    // MARK: - Diffable Data Sources

    /// Modern replacement for UICollectionViewDataSource: type-safe cell
    /// registration, and updates described as snapshots that the framework
    /// diffs and animates. SwiftUI equivalent: ForEach over identified data.
    private lazy var dataSource: UICollectionViewDiffableDataSource<HomeSection, HomeItem> = {
        let movieCell = UICollectionView.CellRegistration<MovieCollectionViewCell, HomeItem> { cell, _, item in
            switch item.section {
            case .nowPlaying, .topRated:
                cell.configure(with: item.movie, showTitle: false)
            case .upcoming, .popular:
                cell.configureWithBackdrop(with: item.movie)
            }
        }

        let header = UICollectionView.SupplementaryRegistration<SectionHeaderView>(
            elementKind: UICollectionView.elementKindSectionHeader
        ) { [weak self] view, _, indexPath in
            guard let section = self?.dataSource.sectionIdentifier(for: indexPath.section) else { return }
            view.configure(with: section.title)
        }

        let dataSource = UICollectionViewDiffableDataSource<HomeSection, HomeItem>(
            collectionView: collectionView
        ) { collectionView, indexPath, item in
            collectionView.dequeueConfiguredReusableCell(using: movieCell, for: indexPath, item: item)
        }

        dataSource.supplementaryViewProvider = { collectionView, _, indexPath in
            collectionView.dequeueConfiguredReusableSupplementary(using: header, for: indexPath)
        }

        return dataSource
    }()

    private lazy var searchDataSource: UITableViewDiffableDataSource<Int, Movie> = {
        searchResultsTableView.register(SearchResultCell.self, forCellReuseIdentifier: SearchResultCell.reuseIdentifier)
        return UITableViewDiffableDataSource<Int, Movie>(
            tableView: searchResultsTableView
        ) { tableView, indexPath, movie in
            let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultCell.reuseIdentifier, for: indexPath)
            (cell as? SearchResultCell)?.configure(with: movie)
            return cell
        }
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
        applySnapshot(animating: false)
        applySearchSnapshot()
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

    // MARK: - Snapshots

    /// Describe the desired end state; diffable diffs and animates the rest.
    private func applySnapshot(animating: Bool = true) {
        var snapshot = NSDiffableDataSourceSnapshot<HomeSection, HomeItem>()
        snapshot.appendSections(HomeSection.allCases)
        snapshot.appendItems(items(for: .nowPlaying, from: presenter.nowPlayingMovies), toSection: .nowPlaying)
        snapshot.appendItems(items(for: .upcoming, from: presenter.upcomingMovies), toSection: .upcoming)
        snapshot.appendItems(items(for: .topRated, from: presenter.topRatedMovies), toSection: .topRated)
        snapshot.appendItems(items(for: .popular, from: presenter.popularMovies), toSection: .popular)
        dataSource.apply(snapshot, animatingDifferences: animating)
    }

    /// Paginated APIs can occasionally repeat an item across pages — snapshot
    /// identifiers must be unique, so de-duplicate defensively per section.
    private func items(for section: HomeSection, from movies: [Movie]) -> [HomeItem] {
        var seen = Set<Int>()
        return movies.compactMap { movie in
            guard seen.insert(movie.id).inserted else { return nil }
            return HomeItem(section: section, movie: movie)
        }
    }

    private func applySearchSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Int, Movie>()
        snapshot.appendSections([0])
        var seen = Set<Int>()
        snapshot.appendItems(presenter.searchedMovies.filter { seen.insert($0.id).inserted })
        searchDataSource.apply(snapshot, animatingDifferences: false)
    }

    // MARK: - Data Loading

    private func loadAllMovies() {
        Task {
            await presenter.loadAllMovies()
        }
    }

    // MARK: - Pagination

    private func checkForPagination(section: HomeSection, index: Int) {
        guard paginatingSections.insert(section).inserted else { return }

        Task {
            defer { paginatingSections.remove(section) }

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
        applySnapshot()
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
        applySnapshot()
    }

    func didLoadSearchResults() {
        applySearchSnapshot()
    }

    func didFailToSearch(with error: Error) {
        showErrorAlert(message: "Search failed. Please try again.")
    }
}

// MARK: - UICollectionViewDelegate
extension HomeViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = dataSource.itemIdentifier(for: indexPath) else { return }
        presenter.onMoviePressed(id: item.movie.id)
    }

    /// Pagination belongs in willDisplay, not cellForItemAt — it fires when a
    /// cell is actually about to appear, and pairs with the in-flight guard.
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let item = dataSource.itemIdentifier(for: indexPath) else { return }
        checkForPagination(section: item.section, index: indexPath.item)
    }
}

// MARK: - UISearchResultsUpdating
extension HomeViewController: UISearchResultsUpdating {

    func updateSearchResults(for searchController: UISearchController) {
        guard let query = searchController.searchBar.text else { return }

        if query.isEmpty {
            searchTask?.cancel()
            Task {
                await presenter.loadSearchedMovies(query: "")
                searchResultsTableView.isHidden = true
                collectionView.isHidden = false
            }
            return
        }

        // Show search results table
        searchResultsTableView.isHidden = false
        collectionView.isHidden = true

        // Debounce: cancel the previous task, wait, then search — the modern
        // replacement for perform(_:afterDelay:) + cancelPreviousPerformRequests.
        searchTask?.cancel()
        searchTask = Task {
            try? await Task.sleep(for: .milliseconds(300))
            guard !Task.isCancelled else { return }
            await presenter.loadSearchedMovies(query: query)
        }
    }
}

// MARK: - UISearchControllerDelegate
extension HomeViewController: UISearchControllerDelegate {

    func willDismissSearchController(_ searchController: UISearchController) {
        searchResultsTableView.isHidden = true
        collectionView.isHidden = false
    }
}

// MARK: - UITableViewDelegate (Search Results)
extension HomeViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        guard let movie = searchDataSource.itemIdentifier(for: indexPath) else { return }
        presenter.onMoviePressed(id: movie.id)

        // Dismiss search when selecting a result
        searchController.isActive = false
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return LayoutConstants.CellHeight.searchResult
    }
}

// MARK: - Preview
/// Mirrors the SceneDelegate wiring with DevPreview mocks — same objects,
/// mock services. The presenter retains the router, so no extra references
/// are needed here.
#Preview("Home — mock data") {
    let builder = CoreBuilder(interactor: CoreInteractor(container: DevPreview.shared.container()))
    let navigationController = UINavigationController()
    let router = UIKitRouter(navigationController: navigationController, builder: builder)
    navigationController.viewControllers = [builder.makeHomeViewController(router: router)]
    return navigationController
}



