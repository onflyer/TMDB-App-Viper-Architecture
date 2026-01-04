//
//  DetailViewController.swift
//  TMDB VIPER
//
//  Created by Aleksandar Milidrag on 22. 12. 2024..
//

import UIKit
import SDWebImage

// MARK: - DetailViewController
/// The UIKit equivalent of your DetailView.
///
/// SwiftUI DetailView uses:
/// - @State var presenter: DetailPresenter
/// - Automatic UI updates via @Observable
///
/// UIKit uses:
/// - Manual UI updates after async operations
/// - IBAction-style button handlers

class DetailViewController: UIViewController {
    
    // MARK: - Properties
    
    private let presenter: DetailPresenter
    private let delegate: DetailViewDelegate
    private var hasLoadedData = false  // Prevent reloading on navigation back
    
    // MARK: - UI Elements
    
    /// Main scroll view for content
    /// SwiftUI equivalent: ScrollView wrapping the content
    private lazy var scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.showsVerticalScrollIndicator = true
        return sv
    }()
    
    /// Content view inside scroll view
    private lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    /// Backdrop image at top
    private lazy var backdropImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .systemGray5
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    /// Poster image (overlapping backdrop)
    private lazy var posterImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 8
        iv.layer.borderWidth = 2
        iv.layer.borderColor = UIColor.white.cgColor
        iv.backgroundColor = .systemGray5
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.isUserInteractionEnabled = true
        return iv
    }()
    
    /// "Watch trailer" button
    private lazy var watchTrailerButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.title = "Watch trailer"
        config.image = UIImage(systemName: "play.fill")
        config.imagePlacement = .trailing
        config.imagePadding = 8
        config.baseBackgroundColor = .systemBackground
        config.baseForegroundColor = .secondaryLabel
        config.cornerStyle = .large
        
        let button = UIButton(configuration: config)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(watchTrailerTapped), for: .touchUpInside)
        return button
    }()
    
    /// Movie title label
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .label
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    /// Genres label
    private lazy var genresLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .secondaryLabel
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    /// Favorite heart button
    private lazy var favoriteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        button.tintColor = .systemRed
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(favoriteTapped), for: .touchUpInside)
        return button
    }()
    
    /// "Local theaters" button
    private lazy var localTheatersButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.title = "Local theaters"
        config.image = UIImage(systemName: "location.fill")
        config.imagePlacement = .trailing
        config.imagePadding = 4
        config.baseForegroundColor = .label
        
        let button = UIButton(configuration: config)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(localTheatersTapped), for: .touchUpInside)
        return button
    }()
    
    /// Release date section
    private lazy var releaseDateTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Release date"
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var releaseDateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    /// Overview section
    private lazy var overviewTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Overview"
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var overviewLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .secondaryLabel
        label.numberOfLines = 0  // Unlimited lines
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    /// Divider line
    private lazy var dividerView: UIView = {
        let view = UIView()
        view.backgroundColor = .separator
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    /// Loading indicator
    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    // MARK: - Initialization
    
    init(presenter: DetailPresenter, delegate: DetailViewDelegate) {
        self.presenter = presenter
        self.delegate = delegate
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
        setupGestures()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        guard !hasLoadedData else { return }
        hasLoadedData = true
        
        loadMovie()
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        // Add scroll view
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        // Add subviews to content view
        contentView.addSubview(backdropImageView)
        contentView.addSubview(posterImageView)
        contentView.addSubview(watchTrailerButton)
        contentView.addSubview(titleLabel)
        contentView.addSubview(genresLabel)
        contentView.addSubview(favoriteButton)
        contentView.addSubview(localTheatersButton)
        contentView.addSubview(dividerView)
        contentView.addSubview(releaseDateTitleLabel)
        contentView.addSubview(releaseDateLabel)
        contentView.addSubview(overviewTitleLabel)
        contentView.addSubview(overviewLabel)
        
        // Add loading indicator
        view.addSubview(loadingIndicator)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        let backdropHeight: CGFloat = 220
        let posterWidth: CGFloat = 120
        let posterHeight: CGFloat = 180
        let posterOverlap: CGFloat = 90  // How much poster overlaps below backdrop
        
        NSLayoutConstraint.activate([
            // Scroll view fills the screen
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // Content view inside scroll view
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            // Backdrop image
            backdropImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            backdropImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            backdropImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            backdropImageView.heightAnchor.constraint(equalToConstant: backdropHeight),
            
            // Poster image (overlapping)
            posterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            posterImageView.topAnchor.constraint(equalTo: backdropImageView.bottomAnchor, constant: -posterOverlap),
            posterImageView.widthAnchor.constraint(equalToConstant: posterWidth),
            posterImageView.heightAnchor.constraint(equalToConstant: posterHeight),
            
            // Watch trailer button (bottom right of backdrop)
            watchTrailerButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            watchTrailerButton.bottomAnchor.constraint(equalTo: backdropImageView.bottomAnchor, constant: -16),
            
            // Title (right of poster)
            titleLabel.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: favoriteButton.leadingAnchor, constant: -8),
            titleLabel.topAnchor.constraint(equalTo: backdropImageView.bottomAnchor, constant: 12),
            
            // Genres (below title)
            genresLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            genresLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            genresLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            
            // Favorite button (right side)
            favoriteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            favoriteButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            favoriteButton.widthAnchor.constraint(equalToConstant: 44),
            favoriteButton.heightAnchor.constraint(equalToConstant: 44),
            
            // Local theaters button (right aligned, below poster area)
            localTheatersButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            localTheatersButton.topAnchor.constraint(equalTo: posterImageView.bottomAnchor, constant: 8),
            
            // Divider
            dividerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            dividerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            dividerView.topAnchor.constraint(equalTo: localTheatersButton.bottomAnchor, constant: 16),
            dividerView.heightAnchor.constraint(equalToConstant: 1),
            
            // Release date title
            releaseDateTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            releaseDateTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            releaseDateTitleLabel.topAnchor.constraint(equalTo: dividerView.bottomAnchor, constant: 16),
            
            // Release date value
            releaseDateLabel.leadingAnchor.constraint(equalTo: releaseDateTitleLabel.leadingAnchor),
            releaseDateLabel.trailingAnchor.constraint(equalTo: releaseDateTitleLabel.trailingAnchor),
            releaseDateLabel.topAnchor.constraint(equalTo: releaseDateTitleLabel.bottomAnchor, constant: 4),
            
            // Overview title
            overviewTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            overviewTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            overviewTitleLabel.topAnchor.constraint(equalTo: releaseDateLabel.bottomAnchor, constant: 20),
            
            // Overview text
            overviewLabel.leadingAnchor.constraint(equalTo: overviewTitleLabel.leadingAnchor),
            overviewLabel.trailingAnchor.constraint(equalTo: overviewTitleLabel.trailingAnchor),
            overviewLabel.topAnchor.constraint(equalTo: overviewTitleLabel.bottomAnchor, constant: 4),
            overviewLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -32),
            
            // Loading indicator (centered)
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
    
    private func setupNavigationBar() {
        title = "Movie Details"
        navigationItem.largeTitleDisplayMode = .never
        
        // Favorites button in nav bar
        let favoritesButton = UIBarButtonItem(
            title: "Favorites",
            style: .plain,
            target: self,
            action: #selector(showFavoritesTapped)
        )
        navigationItem.rightBarButtonItem = favoritesButton
    }
    
    private func setupGestures() {
        // Tap on poster to show full image
        let posterTap = UITapGestureRecognizer(target: self, action: #selector(posterTapped))
        posterImageView.addGestureRecognizer(posterTap)
    }
    
    // MARK: - Data Loading
    
    private func loadMovie() {
        loadingIndicator.startAnimating()
        
        Task {
            await presenter.loadSingleMovie(id: delegate.movieId)
            
            await MainActor.run {
                loadingIndicator.stopAnimating()
                updateUI()
            }
        }
    }
    
    /// Manual UI update - the KEY difference from SwiftUI!
    /// In SwiftUI, @Observable triggers automatic re-render.
    /// In UIKit, we must manually set each UI element.
    private func updateUI() {
        guard let movie = presenter.movie else { return }
        
        // Update title in nav bar
        title = movie.title ?? "Movie Details"
        
        // Update images
        if let backdropURL = movie.backdropURLString, let url = URL(string: backdropURL) {
            backdropImageView.sd_setImage(with: url)
        }
        if let posterURL = movie.posterURLString, let url = URL(string: posterURL) {
            posterImageView.sd_setImage(with: url)
        }
        
        // Update text
        titleLabel.text = movie.title ?? "No title"
        genresLabel.text = movie.genres?.compactMap { $0.name }.joined(separator: ", ") ?? ""
        releaseDateLabel.text = movie.releaseDate ?? "No release date"
        overviewLabel.text = movie.overview ?? "No description"
        
        // Update favorite button
        updateFavoriteButton()
    }
    
    private func updateFavoriteButton() {
        let imageName = presenter.isFavorite ? "heart.fill" : "heart"
        favoriteButton.setImage(UIImage(systemName: imageName), for: .normal)
        
        // Animate the change
        UIView.animate(withDuration: 0.2, animations: {
            self.favoriteButton.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        }) { _ in
            UIView.animate(withDuration: 0.1) {
                self.favoriteButton.transform = .identity
            }
        }
    }
    
    // MARK: - Actions
    
    @objc private func showFavoritesTapped() {
        presenter.onFavoritesPressed()
    }
    
    @objc private func watchTrailerTapped() {
        presenter.onWatchTrailerPressed()
    }
    
    @objc private func posterTapped() {
        presenter.onMovieImagePressed()
    }
    
    @objc private func favoriteTapped() {
        presenter.onHeartPressed()
        updateFavoriteButton()
    }
    
    @objc private func localTheatersTapped() {
        presenter.onLocalTheatersPressed()
    }
}

// MARK: - SwiftUI vs UIKit Comparison
/*
 
 ┌─────────────────────────────────────────────────────────────────┐
 │              DETAIL VIEW COMPARISON                             │
 ├─────────────────────────────────────────────────────────────────┤
 │                                                                 │
 │  SWIFTUI:                                                       │
 │  ────────                                                       │
 │  struct DetailView: View {                                      │
 │      @State var presenter: DetailPresenter                      │
 │                                                                 │
 │      var body: some View {                                      │
 │          Text(presenter.movie?.title ?? "")  // Auto-updates!  │
 │      }                                                          │
 │  }                                                              │
 │                                                                 │
 │  // When presenter.movie changes, body rebuilds automatically   │
 │                                                                 │
 │                                                                 │
 │  UIKIT:                                                         │
 │  ──────                                                         │
 │  class DetailViewController: UIViewController {                 │
 │      let presenter: DetailPresenter                             │
 │      let titleLabel = UILabel()                                 │
 │                                                                 │
 │      func loadMovie() {                                         │
 │          await presenter.loadSingleMovie(id: movieId)           │
 │          updateUI()  // MANUAL call required!                   │
 │      }                                                          │
 │                                                                 │
 │      func updateUI() {                                          │
 │          titleLabel.text = presenter.movie?.title  // Manual!  │
 │      }                                                          │
 │  }                                                              │
 │                                                                 │
 ├─────────────────────────────────────────────────────────────────┤
 │                                                                 │
 │  BUTTON ACTIONS:                                                │
 │                                                                 │
 │  SwiftUI:                                                       │
 │  Button("Tap") { presenter.doSomething() }                     │
 │                                                                 │
 │  UIKit:                                                         │
 │  button.addTarget(self, action: #selector(tapped), ...)        │
 │  @objc func tapped() { presenter.doSomething() }               │
 │                                                                 │
 └─────────────────────────────────────────────────────────────────┘
 
 */
