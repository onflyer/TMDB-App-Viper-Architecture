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

final class MovieCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Reuse Identifier
    static let reuseIdentifier = "MovieCollectionViewCell"
    
    // MARK: - UI Elements
    
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .systemGray5
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .white
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
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
        contentView.layer.cornerRadius = LayoutConstants.CornerRadius.medium
        contentView.clipsToBounds = true
        
        contentView.addSubview(imageView)
        contentView.addSubview(gradientView)
        contentView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            gradientView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            gradientView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            gradientView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            gradientView.heightAnchor.constraint(equalToConstant: 50),
            
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: LayoutConstants.Spacing.medium),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -LayoutConstants.Spacing.medium),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -LayoutConstants.Spacing.medium),
        ])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if gradientLayer == nil {
            let gradient = CAGradientLayer()
            gradient.colors = [UIColor.clear.cgColor, UIColor.black.withAlphaComponent(0.7).cgColor]
            gradient.locations = [0, 1]
            gradient.frame = gradientView.bounds
            gradientView.layer.insertSublayer(gradient, at: 0)
            gradientLayer = gradient
        } else {
            gradientLayer?.frame = gradientView.bounds
        }
    }
    
    // MARK: - Reuse
    
    /// CRITICAL in UIKit - must reset all state!
    /// SwiftUI doesn't need this because views are recreated.
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.sd_cancelCurrentImageLoad()
        imageView.image = nil
        titleLabel.text = nil
    }
    
    // MARK: - Configuration
    
    func configure(with movie: Movie, showTitle: Bool = false) {
        titleLabel.text = showTitle ? movie.title : nil
        titleLabel.isHidden = !showTitle
        gradientView.isHidden = !showTitle
        
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
 │   WHY REUSE?                                                   │
 │                                                                 │
 │   UIKit reuses cells for memory efficiency.                    │
 │   With 1000 movies, only ~10 cells exist (visible ones).       │
 │   SwiftUI does similar optimization internally with LazyHStack │
 │                                                                 │
 └─────────────────────────────────────────────────────────────────┘
 
 */
