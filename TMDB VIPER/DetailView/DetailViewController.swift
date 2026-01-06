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
/// - Delegate pattern for presenter -> VC communication
/// - Manual UI updates after async operations
/// - IBAction-style button handlers

final class DetailViewController: UIViewController {
    
    // MARK: - Properties
    
    private let presenter: DetailPresenter
    private let delegate: DetailViewDelegate
    private var hasLoadedData = false
    
    // MARK: - UI Elements
    
    private lazy var scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.showsVerticalScrollIndicator = true
        return sv
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var backdropImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .systemGray5
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private lazy var posterImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = LayoutConstants.CornerRadius.medium
        iv.layer.borderWidth = 2
        iv.layer.borderColor = UIColor.white.cgColor
        iv.backgroundColor = .systemGray5
        iv.isUserInteractionEnabled = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private lazy var watchTrailerButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Watch trailer ", for: .normal)
        button.setImage(UIImage(systemName: "play.fill"), for: .normal)
        button.semanticContentAttribute = .forceRightToLeft
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .bold)
        button.tintColor = .secondaryLabel
        button.backgroundColor = .systemBackground.withAlphaComponent(0.9)
        button.layer.cornerRadius = LayoutConstants.CornerRadius.large
        button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(watchTrailerTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .label
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var genresLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .secondaryLabel
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var favoriteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        button.tintColor = .systemRed
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(favoriteTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var localTheatersButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Local theaters ", for: .normal)
        button.setImage(UIImage(systemName: "location.fill"), for: .normal)
        button.semanticContentAttribute = .forceRightToLeft
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .bold)
        button.tintColor = .systemOrange
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(localTheatersTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var dividerView: UIView = {
        let view = UIView()
        view.backgroundColor = .separator
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
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
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
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
        
        // Wire up the delegate - KEY for UIKit
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
        setupImageTapGestures()
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
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
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
        
        view.addSubview(loadingIndicator)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        let backdropHeight = LayoutConstants.Backdrop.Detail.height
        let posterWidth = LayoutConstants.Poster.Detail.width
        let posterHeight = LayoutConstants.Poster.Detail.height
        let posterOverlap: CGFloat = 90
        
        NSLayoutConstraint.activate([
            // Scroll view
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // Content view
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            // Backdrop
            backdropImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            backdropImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            backdropImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            backdropImageView.heightAnchor.constraint(equalToConstant: backdropHeight),
            
            // Poster
            posterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: LayoutConstants.Spacing.large),
            posterImageView.topAnchor.constraint(equalTo: backdropImageView.bottomAnchor, constant: -posterOverlap),
            posterImageView.widthAnchor.constraint(equalToConstant: posterWidth),
            posterImageView.heightAnchor.constraint(equalToConstant: posterHeight),
            
            // Watch trailer button
            watchTrailerButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -LayoutConstants.Spacing.standard),
            watchTrailerButton.bottomAnchor.constraint(equalTo: backdropImageView.bottomAnchor, constant: -LayoutConstants.Spacing.standard),
            
            // Title
            titleLabel.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: LayoutConstants.Spacing.standard),
            titleLabel.trailingAnchor.constraint(equalTo: favoriteButton.leadingAnchor, constant: -LayoutConstants.Spacing.medium),
            titleLabel.topAnchor.constraint(equalTo: backdropImageView.bottomAnchor, constant: LayoutConstants.Spacing.medium),
            
            // Genres
            genresLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            genresLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            genresLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: LayoutConstants.Spacing.small),
            
            // Favorite button
            favoriteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -LayoutConstants.Spacing.standard),
            favoriteButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            favoriteButton.widthAnchor.constraint(equalToConstant: LayoutConstants.Button.standard),
            favoriteButton.heightAnchor.constraint(equalToConstant: LayoutConstants.Button.standard),
            
            // Local theaters button
            localTheatersButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -LayoutConstants.Spacing.standard),
            localTheatersButton.topAnchor.constraint(equalTo: posterImageView.bottomAnchor, constant: LayoutConstants.Spacing.medium),
            
            // Divider
            dividerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            dividerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            dividerView.topAnchor.constraint(equalTo: localTheatersButton.bottomAnchor, constant: LayoutConstants.Spacing.standard),
            dividerView.heightAnchor.constraint(equalToConstant: 1),
            
            // Release date title
            releaseDateTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: LayoutConstants.Spacing.large),
            releaseDateTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -LayoutConstants.Spacing.large),
            releaseDateTitleLabel.topAnchor.constraint(equalTo: dividerView.bottomAnchor, constant: LayoutConstants.Spacing.standard),
            
            // Release date value
            releaseDateLabel.leadingAnchor.constraint(equalTo: releaseDateTitleLabel.leadingAnchor),
            releaseDateLabel.trailingAnchor.constraint(equalTo: releaseDateTitleLabel.trailingAnchor),
            releaseDateLabel.topAnchor.constraint(equalTo: releaseDateTitleLabel.bottomAnchor, constant: LayoutConstants.Spacing.small),
            
            // Overview title
            overviewTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: LayoutConstants.Spacing.large),
            overviewTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -LayoutConstants.Spacing.large),
            overviewTitleLabel.topAnchor.constraint(equalTo: releaseDateLabel.bottomAnchor, constant: LayoutConstants.Spacing.large),
            
            // Overview text
            overviewLabel.leadingAnchor.constraint(equalTo: overviewTitleLabel.leadingAnchor),
            overviewLabel.trailingAnchor.constraint(equalTo: overviewTitleLabel.trailingAnchor),
            overviewLabel.topAnchor.constraint(equalTo: overviewTitleLabel.bottomAnchor, constant: LayoutConstants.Spacing.small),
            overviewLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -LayoutConstants.Spacing.extraLarge),
            
            // Loading indicator
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
    
    private func setupNavigationBar() {
        title = "Movie Details"
        navigationItem.largeTitleDisplayMode = .never
        
        let favoritesButton = UIBarButtonItem(
            title: "Favorites",
            style: .plain,
            target: self,
            action: #selector(showFavoritesTapped)
        )
        navigationItem.rightBarButtonItem = favoritesButton
    }
    
    private func setupGestures() {
        let posterTap = UITapGestureRecognizer(target: self, action: #selector(posterTapped))
        posterImageView.addGestureRecognizer(posterTap)
    }
    
    // MARK: - Data Loading
    
    private func loadMovie() {
        loadingIndicator.startAnimating()
        scrollView.isHidden = true
        
        Task {
            await presenter.loadSingleMovie(id: delegate.movieId)
        }
    }
    
    // MARK: - UI Updates
    
    private func updateUI() {
        guard let movie = presenter.movie else { return }
        
        title = movie.title ?? "Movie Details"
        
        if let backdropURL = movie.backdropURLString, let url = URL(string: backdropURL) {
            backdropImageView.sd_setImage(with: url)
        }
        if let posterURL = movie.posterURLString, let url = URL(string: posterURL) {
            posterImageView.sd_setImage(with: url)
        }
        
        titleLabel.text = movie.title ?? "No title"
        genresLabel.text = movie.genres?.compactMap { $0.name }.joined(separator: ", ") ?? ""
        releaseDateLabel.text = movie.releaseDate ?? "No release date"
        overviewLabel.text = movie.overview ?? "No description"
        
        updateFavoriteButton()
    }
    
    private func updateFavoriteButton() {
        let imageName = presenter.isFavorite ? "heart.fill" : "heart"
        favoriteButton.setImage(UIImage(systemName: imageName), for: .normal)
        
        UIView.animate(withDuration: 0.2, animations: {
            self.favoriteButton.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        }) { _ in
            UIView.animate(withDuration: 0.1) {
                self.favoriteButton.transform = .identity
            }
        }
    }
    
    // MARK: - Error Handling
    
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
    }
    
    @objc private func localTheatersTapped() {
        presenter.onLocalTheatersPressed()
    }
}

// MARK: - DetailPresenterDelegate
extension DetailViewController: DetailPresenterDelegate {
    
    func didLoadMovie() {
        loadingIndicator.stopAnimating()
        scrollView.isHidden = false
        updateUI()
    }
    
    func didFailToLoadMovie(with error: Error) {
        loadingIndicator.stopAnimating()
        showErrorAlert(message: "Failed to load movie details. Please try again.") { [weak self] in
            self?.loadMovie()
        }
    }
    
    func didUpdateFavoriteStatus() {
        updateFavoriteButton()
    }
    
    func didFailToUpdateFavorite(with error: Error) {
        showErrorAlert(message: "Failed to update favorites. Please try again.")
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
 │  UIKIT (with Delegate):                                         │
 │  ──────────────────────                                         │
 │  class DetailViewController: UIViewController {                 │
 │      let presenter: DetailPresenter                             │
 │      let titleLabel = UILabel()                                 │
 │                                                                 │
 │      init(presenter: DetailPresenter) {                        │
 │          presenter.delegate = self  // Wire up delegate        │
 │      }                                                          │
 │                                                                 │
 │      func didLoadMovie() {  // Called by presenter             │
 │          titleLabel.text = presenter.movie?.title              │
 │      }                                                          │
 │  }                                                              │
 │                                                                 │
 ├─────────────────────────────────────────────────────────────────┤
 │                                                                 │
 │  THE KEY INSIGHT:                                               │
 │  Delegate pattern replaces @Observable automatic updates        │
 │                                                                 │
 └─────────────────────────────────────────────────────────────────┘
 
 */

//
//  DetailViewController+ImageModal.swift
//  TMDB VIPER
//
//  Extension for presenting image modal with iOS 18+ zoom transition.
//  Add this to your DetailViewController or merge into existing file.
//


extension DetailViewController {
    
    // MARK: - Setup
    
    /// Call this in your setupGestures() method
    func setupImageTapGestures() {
        // Poster image tap
        posterImageView.isUserInteractionEnabled = true
        let posterTap = UITapGestureRecognizer(target: self, action: #selector(posterImageTapped))
        posterImageView.addGestureRecognizer(posterTap)
        
        // Backdrop image tap (optional)
        backdropImageView.isUserInteractionEnabled = true
        let backdropTap = UITapGestureRecognizer(target: self, action: #selector(backdropImageTapped))
        backdropImageView.addGestureRecognizer(backdropTap)
    }
    
    // MARK: - Actions
    
    @objc private func posterImageTapped() {
        presentImageModal(
            urlString: presenter.movie?.posterURLString ?? "",
            sourceView: posterImageView
        )
    }
    
    @objc private func backdropImageTapped() {
        presentImageModal(
            urlString: presenter.movie?.backdropURLString ?? "",
            sourceView: backdropImageView
        )
    }
    
    // MARK: - Present with Zoom
    
    /// Presents the image modal with iOS 18+ zoom transition.
    /// - Parameters:
    ///   - urlString: URL for the full-size image
    ///   - sourceView: The view to zoom from/to
    private func presentImageModal(urlString: String, sourceView: UIView) {
        let modalVC = ImageModalViewController(
            imageURLString: urlString,
            onDismiss: { }
        )
        
        modalVC.modalPresentationStyle = .automatic
        modalVC.preferredTransition = .zoom { _ in
            return sourceView
        }
        
        present(modalVC, animated: true)
    }
}
