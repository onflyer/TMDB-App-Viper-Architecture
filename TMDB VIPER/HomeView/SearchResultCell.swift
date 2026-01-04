//
//  SearchResultCell.swift
//  TMDB VIPER
//
//  Created by Aleksandar Milidrag on 22. 12. 2024..
//

import UIKit
import SDWebImage

// MARK: - SearchResultCell
/// Table view cell for search results.
/// UIKit equivalent of SearchCellView in SwiftUI.

final class SearchResultCell: UITableViewCell {
    
    // MARK: - Reuse Identifier
    static let reuseIdentifier = "SearchResultCell"
    
    // MARK: - UI Elements
    
    private let posterImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = LayoutConstants.CornerRadius.medium
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
    
    private lazy var textStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [titleLabel, releaseDateLabel, ratingLabel])
        stack.axis = .vertical
        stack.spacing = LayoutConstants.Spacing.small
        stack.alignment = .leading
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var mainStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [posterImageView, textStackView])
        stack.axis = .horizontal
        stack.spacing = LayoutConstants.Spacing.standard
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
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
            posterImageView.widthAnchor.constraint(equalToConstant: LayoutConstants.Poster.Small.width),
            posterImageView.heightAnchor.constraint(equalToConstant: LayoutConstants.Poster.Small.height),
            
            mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: LayoutConstants.Spacing.medium),
            mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: LayoutConstants.Spacing.standard),
            mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -LayoutConstants.Spacing.standard),
            mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -LayoutConstants.Spacing.medium),
        ])
    }
    
    // MARK: - Configuration
    
    func configure(with movie: Movie) {
        titleLabel.text = movie.title ?? "Unknown Title"
        releaseDateLabel.text = movie.releaseDateForrmated ?? movie.releaseDate ?? "Unknown Date"
        ratingLabel.text = movie.ratingText ?? "No Rating"
        
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
