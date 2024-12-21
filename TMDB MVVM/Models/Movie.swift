//
//  Movie.swift
//  TMDB App
//
//  Created by Aleksandar Milidrag on 3/14/24.
//

import Foundation

struct Movie: Identifiable, Codable {
    
    let adult: Bool?
    let backdropPath: String?
    let genreIDS: [Int]?
    let id: Int?
    let originalTitle, overview: String?
    let popularity: Double?
    let posterPath: String?
    let releaseDate: String?
    let title: String?
    let video: Bool?
    let voteAverage: Double?
    let voteCount: Int?
    
    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case genreIDS = "genre_ids"
        case id
//        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview, popularity
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title
        case video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
    
    
    var posterURLString: String? {
        guard let unwrappedUrl = posterPath else { return nil }
        return "https://image.tmdb.org/t/p/w500\(unwrappedUrl)"
    }
    var backdropURLString: String? {
        guard let unwrappedUrl = backdropPath else { return nil }
        return "https://image.tmdb.org/t/p/w500\(unwrappedUrl)"
    }
    
    var yearText: String? {
        guard let unwrappedReleaseDate = releaseDate else { return nil }
        guard let date = Movie.dateFormatter.date(from: unwrappedReleaseDate
        ) else {
            return nil
        }
        return Movie.yearFormatter.string(from: date)
    }
    var ratingText: String? {
        guard let unwrappedVoteAverage = voteAverage else { return nil }
        let rating = Int(unwrappedVoteAverage)
        let ratingText = (0..<rating).reduce("") { (acc, _) -> String in
            return acc + "★"
        }
        return ratingText
    }
    var scoreText: String? {
        guard let unwrappedRatingText = ratingText else {return nil}
        guard unwrappedRatingText.count > 0 else {
            return "n/a"
        }
        return "\(unwrappedRatingText.count)/10"
    }
    static private let yearFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        return formatter
    }()
    
    static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-mm-dd"
        return dateFormatter
    }()

    
}
    
    
extension Movie: Hashable {
    static func == (lhs: Movie, rhs: Movie) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
