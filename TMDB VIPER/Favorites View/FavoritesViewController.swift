//
//  FavoritesViewController.swift
//  TMDB VIPER
//
//  Created by Aleksandar Milidrag on 22. 12. 2024..
//

import UIKit
import SDWebImage

// MARK: - FavoritesViewController
/// The UIKit equivalent of your FavoritesView.
///
/// Uses UITableView instead of List - same concept, different API.
///
/// SwiftUI FavoritesView:
/// ```
/// List {
///     ForEach(presenter.favoriteMovies) { movie in
///         SearchCellView(...)
///             .onTapGesture { presenter.onMoviePressed(id: movie.id) }
///     }
///     .onDelete { presenter.removeFavorite(at: $0) }
/// }
/// ```

class FavoritesViewController: UIViewController {
    
    // MARK: - Properties
    
    private let presenter: FavoritesPresenter
    
    // MARK: - UI Elements
    
    /// Table view displaying favorite movies.
    /// SwiftUI equivalent: List { ForEach(...) }
    private lazy var tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .plain)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.delegate = self
        tv.dataSource = self
        tv.register(FavoriteMovieCell.self, forCellReuseIdentifier: FavoriteMovieCell.reuseIdentifier)
        tv.rowHeight = 100
        tv.separatorStyle = .singleLine
        return tv
    }()
    
    /// Empty state view when no favorites.
    /// SwiftUI equivalent: ContentUnavailableView
    private lazy var emptyStateView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        
        let imageView = UIImageView(image: UIImage(systemName: "movieclapper.fill"))
        imageView.tintColor = .secondaryLabel
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        let label = UILabel()
        label.text = "No favorite movies, add some to the list..."
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(imageView)
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -30),
            imageView.widthAnchor.constraint(equalToConstant: 60),
            imageView.heightAnchor.constraint(equalToConstant: 60),
            
            label.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
        ])
        
        return view
    }()
    
    // MARK: - Initialization
    
    init(presenter: FavoritesPresenter) {
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadFavorites()
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(tableView)
        view.addSubview(emptyStateView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            emptyStateView.topAnchor.constraint(equalTo: view.topAnchor),
            emptyStateView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            emptyStateView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            emptyStateView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    private func setupNavigationBar() {
        title = "Favorites"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    // MARK: - Data Loading
    
    private func loadFavorites() {
        presenter.loadFavorites()
        updateUI()
    }
    
    private func updateUI() {
        let isEmpty = presenter.favoriteMovies.isEmpty
        emptyStateView.isHidden = !isEmpty
        tableView.isHidden = isEmpty
        
        if !isEmpty {
            tableView.reloadData()
        }
    }
}

// MARK: - UITableViewDataSource
extension FavoritesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.favoriteMovies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: FavoriteMovieCell.reuseIdentifier,
            for: indexPath
        ) as? FavoriteMovieCell else {
            return UITableViewCell()
        }
        
        let movie = presenter.favoriteMovies[indexPath.row]
        cell.configure(with: movie)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension FavoritesViewController: UITableViewDelegate {
    
    /// Handle row tap - navigate to detail.
    /// SwiftUI equivalent: .onTapGesture { presenter.onMoviePressed(id:) }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let movie = presenter.favoriteMovies[indexPath.row]
        presenter.onMoviePressed(id: movie.id)
    }
    
    /// Enable swipe-to-delete.
    /// SwiftUI equivalent: .onDelete { presenter.removeFavorite(at: $0) }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Remove from presenter (persistent storage)
            presenter.removeFavorite(at: IndexSet(integer: indexPath.row))
            
            // Reload favorites from storage to sync the array
            presenter.loadFavorites()
            
            // Reload table (safer than animated deleteRows)
            tableView.reloadData()
            
            // Check if empty
            if presenter.favoriteMovies.isEmpty {
                updateUI()
            }
        }
    }
}

// MARK: - FavoriteMovieCell
/// Custom table view cell for displaying favorite movies.
/// SwiftUI equivalent: SearchCellView
class FavoriteMovieCell: UITableViewCell {
    
    static let reuseIdentifier = "FavoriteMovieCell"
    
    // MARK: - UI Elements
    
    private let posterImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 8
        iv.backgroundColor = .systemGray5
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .label
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let releaseDateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let ratingLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .systemYellow
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Initialization
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        contentView.addSubview(posterImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(releaseDateLabel)
        contentView.addSubview(ratingLabel)
        
        NSLayoutConstraint.activate([
            posterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            posterImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            posterImageView.widthAnchor.constraint(equalToConstant: 60),
            posterImageView.heightAnchor.constraint(equalToConstant: 90),
            
            titleLabel.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            titleLabel.topAnchor.constraint(equalTo: posterImageView.topAnchor),
            
            releaseDateLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            releaseDateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            
            ratingLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            ratingLabel.topAnchor.constraint(equalTo: releaseDateLabel.bottomAnchor, constant: 4),
        ])
    }
    
    // MARK: - Configuration
    
    func configure(with movie: SingleMovie) {
        titleLabel.text = movie.title ?? "No title"
        releaseDateLabel.text = movie.releaseDate ?? "No release date"
        ratingLabel.text = movie.ratingText ?? "No rating"
        
        if let urlString = movie.posterURLString, let url = URL(string: urlString) {
            posterImageView.sd_setImage(with: url)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        posterImageView.image = nil
        titleLabel.text = nil
        releaseDateLabel.text = nil
        ratingLabel.text = nil
        posterImageView.sd_cancelCurrentImageLoad()
    }
}

// MARK: - SwiftUI vs UIKit Comparison
/*
 
 ┌─────────────────────────────────────────────────────────────────┐
 │              LIST vs TABLEVIEW                                  │
 ├─────────────────────────────────────────────────────────────────┤
 │                                                                 │
 │  SWIFTUI List:                                                  │
 │  ─────────────                                                  │
 │  List {                                                         │
 │      ForEach(movies) { movie in                                │
 │          SearchCellView(movie: movie)                          │
 │      }                                                          │
 │      .onDelete { indices in                                    │
 │          presenter.removeFavorite(at: indices)                 │
 │      }                                                          │
 │  }                                                              │
 │                                                                 │
 │                                                                 │
 │  UIKIT UITableView:                                            │
 │  ──────────────────                                            │
 │  // DataSource                                                  │
 │  func numberOfRowsInSection -> Int {                           │
 │      return movies.count                                       │
 │  }                                                              │
 │                                                                 │
 │  func cellForRowAt -> UITableViewCell {                        │
 │      let cell = dequeue...                                     │
 │      cell.configure(with: movie)                               │
 │      return cell                                               │
 │  }                                                              │
 │                                                                 │
 │  // Delegate                                                    │
 │  func commit editingStyle {                                    │
 │      if editingStyle == .delete {                              │
 │          presenter.removeFavorite(...)                         │
 │          tableView.deleteRows(...)                             │
 │      }                                                          │
 │  }                                                              │
 │                                                                 │
 ├─────────────────────────────────────────────────────────────────┤
 │                                                                 │
 │  KEY DIFFERENCES:                                               │
 │  - SwiftUI: Declarative, automatic                             │
 │  - UIKit: Delegate/DataSource pattern, manual animations       │
 │  - SwiftUI: .onDelete modifier                                 │
 │  - UIKit: commit editingStyle delegate method                  │
 │                                                                 │
 └─────────────────────────────────────────────────────────────────┘
 
 */
