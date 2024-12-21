//
//  AddMovieToFavoritesDTO.swift
//  TMDB App
//
//  Created by Aleksandar Milidrag on 3/17/24.
//

import Foundation

struct PostMovieToFavoritesRequest: Codable {
    let mediaType: String = "movie"
    let mediaID: Int
    let favorite: Bool = true

    enum CodingKeys: String, CodingKey {
        case mediaType = "media_type"
        case mediaID = "media_id"
        case favorite
    }
}


