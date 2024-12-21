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


extension Movie {
    static func mocks() -> [Movie] {
        let path = "https://image.tmdb.org/t/p/w500/"
        return [
            Movie(
                adult: false,
                backdropPath: "\(path)t5zCBSB5xMDKcDqe91qahCOUYVV.jpg",
                genreIDS: [28, 12, 16],
                id: 1,
                originalTitle: "Original Title 1",
                overview: "This is the overview for movie 1.",
                popularity: 123.45,
                posterPath: "\(path)t5zCBSB5xMDKcDqe91qahCOUYVV.jpg",
                releaseDate: "2024-03-14",
                title: "Mock Movie 1",
                video: false,
                voteAverage: 8.5,
                voteCount: 1200
            ),
            Movie(
                adult: false,
                backdropPath: "\(path)t5zCBSB5xMDKcDqe91qahCOUYVV.jpg",
                genreIDS: [18, 10749],
                id: 2,
                originalTitle: "Original Title 2",
                overview: "This is the overview for movie 2.",
                popularity: 234.56,
                posterPath: "\(path)t5zCBSB5xMDKcDqe91qahCOUYVV.jpg",
                releaseDate: "2023-11-10",
                title: "Mock Movie 2",
                video: false,
                voteAverage: 7.2,
                voteCount: 850
            ),
            Movie(
                adult: true,
                backdropPath: "\(path)t5zCBSB5xMDKcDqe91qahCOUYVV.jpg",
                genreIDS: [27, 53],
                id: 3,
                originalTitle: "Original Title 3",
                overview: "This is the overview for movie 3.",
                popularity: 87.65,
                posterPath: "\(path)t5zCBSB5xMDKcDqe91qahCOUYVV.jpg",
                releaseDate: "2022-05-20",
                title: "Mock Movie 3",
                video: false,
                voteAverage: 6.9,
                voteCount: 560
            ),
            Movie(
                adult: true,
                backdropPath: "\(path)t5zCBSB5xMDKcDqe91qahCOUYVV.jpg",
                genreIDS: [27, 53],
                id: 3,
                originalTitle: "Original Title 4",
                overview: "This is the overview for movie 3.",
                popularity: 87.65,
                posterPath: "\(path)t5zCBSB5xMDKcDqe91qahCOUYVV.jpg",
                releaseDate: "2022-05-20",
                title: "Mock Movie 3",
                video: false,
                voteAverage: 6.9,
                voteCount: 560
            )
        ]
    }
}
