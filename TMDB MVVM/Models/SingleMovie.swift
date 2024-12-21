//
//  SingleMovie.swift
//  TMDB App
//
//  Created by Aleksandar Milidrag on 3/14/24.
//

import Foundation


struct SingleMovie: Identifiable, Codable {
    let adult: Bool?
    let backdropPath: String?
    let budget: Int?
    let genres: [Genre]?
    let homepage: String?
    let id: Int?
    let imdbID, originalLanguage, originalTitle, overview: String?
    let popularity: Double?
    let posterPath: String?
    let releaseDate: String?
    let revenue, runtime: Int?
    let status, tagline, title: String?
    let video: Bool?
    let voteAverage: Double?
    let voteCount: Int?
    let videos: MovieVideoResponse?
    let credits: Credits?
    
    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case budget, genres, homepage, id
        case imdbID = "imdb_id"
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview, popularity
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case revenue, runtime
        case status, tagline, title, video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case videos, credits
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
        guard let date = SingleMovie.dateFormatter.date(from: unwrappedReleaseDate
        ) else {
            return nil
        }
        return SingleMovie.yearFormatter.string(from: date)
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
    
    var durationText: String? {
        guard let unwrappedRuntime = runtime else {return "n/a"}
        
        return SingleMovie.durationFormatter.string(from: TimeInterval(unwrappedRuntime) * 60)
        }
    
    static private let yearFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        return formatter
    }()
    
    static private let durationFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .full
        formatter.allowedUnits = [.hour, .minute]
        return formatter
    }()
    
    static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-mm-dd"
        return dateFormatter
    }()
    }
    
   
    

struct Credits: Codable {
    let cast, crew: [Cast]?
    
    var directors: [Cast]? {
        guard let unwrappedCrew = crew else { return nil }
       let directors = unwrappedCrew.filter { $0.job?.lowercased() == "director" }
        return directors
     }
    
    var producers: [Cast]? {
        guard let unwrappedCrew = crew else {return nil}
       let producers = unwrappedCrew.filter { $0.job?.lowercased() == "producer" }
        return producers
    }
    
    var screenWriters: [Cast]? {
        guard let unwrappedCrew = crew else {
            return nil
        }
       let writers = unwrappedCrew.filter { $0.job?.lowercased() == "writer" }
        return writers
    }
    
}

// MARK: - Cast
struct Cast: Identifiable, Codable {
    let adult: Bool?
    let gender, id: Int?
    let knownForDepartment, name, originalName: String?
    let popularity: Double
    let profilePath: String?
    let castID: Int?
    let character: String?
    let creditID: String
    let order: Int?
    let department, job: String?
    
    enum CodingKeys: String, CodingKey {
        case adult, gender, id
        case knownForDepartment = "known_for_department"
        case name
        case originalName = "original_name"
        case popularity
        case profilePath = "profile_path"
        case castID = "cast_id"
        case character
        case creditID = "credit_id"
        case order, department, job
    }
}

// MARK: - Genre
struct Genre: Identifiable, Codable {
    let id: Int?
    let name: String?
}

// MARK: - Videos
struct MovieVideoResponse: Codable {
    let results: [MovieVideo]?
}

// MARK: - Result
struct MovieVideo: Identifiable, Codable {
    let name, key: String?
    let site: String?
    let id: String?
    
    enum CodingKeys: String, CodingKey {
        case name, key, site
        case id
    }
    
    var youtubeURL: URL? {
        guard let unwrappedSite = site else {return nil}
        guard unwrappedSite == "YouTube" else {
            return nil
        }
        guard let unwrappedKey = key else {return nil}
        return URL(string: "https://youtube.com/watch?v=\(unwrappedKey)")
    }
}
