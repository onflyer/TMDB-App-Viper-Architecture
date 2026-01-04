//
//  MovieCollectionViewCell.swift
//  TMDB VIPER
//
//  Created by Aleksandar Milidrag on 22. 12. 2024..
//

import UIKit
import SDWebImage

// MARK: - MovieCollectionViewCell
/// The UIKit equivalent of your MovieCellView.
///
/// Key Differences from SwiftUI:
/// - SwiftUI: View struct recreated each time, stateless
/// - UIKit: Cell class is REUSED, must reset state in prepareForReuse()
///
/// SwiftUI MovieCellView:
/// ```
/// struct MovieCellView: View {
///     var title: String
///     var imageName: String
///     var body: some View {
///         ImageLoaderView(urlString: imageName)
///             .overlay(alignment: .bottomLeading) {
///                 Text(title)
///             }
///             .cornerRadius(8)
///     }
/// }
/// ```

class MovieCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Reuse Identifier
    /// Used by UICollectionView to recycle cells
    /// SwiftUI doesn't have this concept - it creates new views as needed
    static let reuseIdentifier = "MovieCollectionViewCell"
    
    // MARK: - UI Elements
    
    /// The movie poster image
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .systemGray5  // Placeholder color while loading
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    /// The movie title label (shown at bottom)
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .white
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    /// Gradient view behind title for readability
    /// SwiftUI equivalent: .addingGradientBackgroundForText()
    private let gradientView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var gradientLayer: CAGradientLayer?
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        // Round corners like SwiftUI's .cornerRadius(8)
        contentView.layer.cornerRadius = 8
        contentView.clipsToBounds = true
        
        // Add shadow (on the cell itself, not contentView)
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 4
        layer.masksToBounds = false
        
        // Add subviews
        contentView.addSubview(imageView)
        contentView.addSubview(gradientView)
        contentView.addSubview(titleLabel)
        
        // Layout constraints
        NSLayoutConstraint.activate([
            // Image fills the entire cell
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            // Gradient at bottom
            gradientView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            gradientView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            gradientView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            gradientView.heightAnchor.constraint(equalToConstant: 50),
            
            // Title at bottom with padding
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
        ])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupGradient()
    }
    
    private func setupGradient() {
        // Remove existing gradient
        gradientLayer?.removeFromSuperlayer()
        
        // Create gradient layer
        let gradient = CAGradientLayer()
        gradient.frame = gradientView.bounds
        gradient.colors = [
            UIColor.clear.cgColor,
            UIColor.black.withAlphaComponent(0.7).cgColor
        ]
        gradient.locations = [0.0, 1.0]
        gradientView.layer.insertSublayer(gradient, at: 0)
        gradientLayer = gradient
    }
    
    // MARK: - Reuse
    
    /// Called when cell is about to be reused.
    /// CRITICAL in UIKit - must reset all state!
    /// SwiftUI doesn't need this because views are recreated.
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        titleLabel.text = nil
        // Cancel any pending image download
        imageView.sd_cancelCurrentImageLoad()
    }
    
    // MARK: - Configuration
    
    /// Configure the cell with movie data.
    /// This is called from cellForItemAt in the data source.
    ///
    /// SwiftUI equivalent: Just passing properties to the view initializer
    /// ```
    /// MovieCellView(title: movie.title, imageName: movie.posterURLString)
    /// ```
    func configure(with movie: Movie, showTitle: Bool = false) {
        // Set title
        titleLabel.text = showTitle ? movie.title : nil
        titleLabel.isHidden = !showTitle
        gradientView.isHidden = !showTitle
        
        // Load image using SDWebImage
        // SwiftUI equivalent: ImageLoaderView (which uses SDWebImageSwiftUI internally)
        if let urlString = movie.posterURLString, let url = URL(string: urlString) {
            imageView.sd_setImage(
                with: url,
                placeholderImage: nil,
                options: [.retryFailed, .scaleDownLargeImages],
                context: nil
            )
        } else if let urlString = movie.backdropURLString, let url = URL(string: urlString) {
            imageView.sd_setImage(with: url)
        }
    }
    
    /// Configure with backdrop image (for wider cells like Upcoming)
    func configureWithBackdrop(with movie: Movie) {
        titleLabel.text = movie.title
        titleLabel.isHidden = false
        gradientView.isHidden = false
        
        if let urlString = movie.backdropURLString, let url = URL(string: urlString) {
            imageView.sd_setImage(with: url)
        }
    }
}

// MARK: - SwiftUI vs UIKit Cell Comparison
/*
 
 ┌─────────────────────────────────────────────────────────────────┐
 │                    CELL COMPARISON                              │
 ├─────────────────────────────────────────────────────────────────┤
 │                                                                 │
 │   SwiftUI (Declarative):                                       │
 │   ──────────────────────                                       │
 │   ForEach(movies) { movie in                                   │
 │       MovieCellView(                                           │
 │           title: movie.title,        // Just pass data         │
 │           imageName: movie.poster    // View handles the rest  │
 │       )                                                        │
 │   }                                                            │
 │   // SwiftUI creates new view structs as needed                │
 │   // No manual cleanup required                                │
 │                                                                 │
 │   UIKit (Imperative):                                          │
 │   ──────────────────                                           │
 │   func collectionView(cellForItemAt indexPath:) -> Cell {      │
 │       let cell = dequeueReusableCell(...)  // Get recycled cell│
 │       cell.configure(with: movie)          // Manually config  │
 │       return cell                                              │
 │   }                                                            │
 │   // Cell is REUSED - must implement prepareForReuse()         │
 │   // to clean up old data                                      │
 │                                                                 │
 ├─────────────────────────────────────────────────────────────────┤
 │                                                                 │
 │   WHY REUSE?                                                    │
 │   UIKit reuses cells for memory efficiency.                    │
 │   With 1000 movies, only ~10 cells exist (visible ones).       │
 │   SwiftUI does similar optimization internally with LazyHStack │
 │                                                                 │
 └─────────────────────────────────────────────────────────────────┘
 
 */
