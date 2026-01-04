//
//  SearchResultCell.swift
//  TMDB VIPER
//
//  Created by Aleksandar Milidrag on 22. 12. 2024..
//

import UIKit
import SDWebImage

// MARK: - SearchResultCell
/// UIKit equivalent of your SearchCellView.
///
/// COMPARISON:
/// ┌─────────────────────────────────────────────────────────────┐
/// │  SwiftUI SearchCellView         │  UIKit SearchResultCell   │
/// ├─────────────────────────────────────────────────────────────┤
/// │  HStack { }                     │  UIStackView horizontal   │
/// │  ImageLoaderView(url)           │  UIImageView + SDWebImage │
/// │    .frame(width: 60, height: 90)│  widthAnchor/heightAnchor │
/// │  VStack(alignment: .leading)    │  UIStackView vertical     │
/// │    Text(title).font(.headline)  │  UILabel with .headline   │
/// │    Text(date).font(.subheadline)│  UILabel with .subheadline│
/// │    Text(rating).foregroundColor │  UILabel with .systemYellow│
/// └─────────────────────────────────────────────────────────────┘

class SearchResultCell: UITableViewCell {
    
    static let reuseIdentifier = "SearchResultCell"
    
    // MARK: - UI Elements
    
    private let posterImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 8
        iv.backgroundColor = .systemGray5
        return iv
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .headline)
        label.textColor = .label
        label.numberOfLines = 2
        return label
    }()
    
    private let releaseDateLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let ratingLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.textColor = .systemYellow
        return label
    }()
    
    private lazy var textStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [titleLabel, releaseDateLabel, ratingLabel])
        sv.axis = .vertical
        sv.spacing = 4
        sv.alignment = .leading
        return sv
    }()
    
    private lazy var mainStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [posterImageView, textStackView])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .horizontal
        sv.spacing = 16
        sv.alignment = .center
        return sv
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
        contentView.addSubview(mainStackView)
        
        NSLayoutConstraint.activate([
            // Poster image size (60x90 like SwiftUI version)
            posterImageView.widthAnchor.constraint(equalToConstant: 60),
            posterImageView.heightAnchor.constraint(equalToConstant: 90),
            
            // Main stack fills the cell with padding
            mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
        ])
    }
    
    // MARK: - Configuration
    
    func configure(with movie: Movie) {
        titleLabel.text = movie.title ?? "Unknown Title"
        releaseDateLabel.text = movie.releaseDateForrmated ?? movie.releaseDate ?? "Unknown Date"
        ratingLabel.text = movie.ratingText ?? "No Rating"
        
        // Load poster image
        if let urlString = movie.posterURLString,
           let url = URL(string: urlString) {
            posterImageView.sd_setImage(with: url, placeholderImage: nil)
        } else {
            posterImageView.image = nil
        }
    }
    
    // MARK: - Reuse
    
    override func prepareForReuse() {
        super.prepareForReuse()
        posterImageView.sd_cancelCurrentImageLoad()
        posterImageView.image = nil
        titleLabel.text = nil
        releaseDateLabel.text = nil
        ratingLabel.text = nil
    }
}
