//
//  SwiftDataLocalMoviePersistence.swift
//  TMDB VIPER
//
//  Created by Aleksandar Milidrag on 12. 1. 2025..
//

import SwiftData
import SwiftUI

@MainActor
struct SwiftDataFavoriteMoviesServiceProd: FavoriteMoviesService {
    
    private let container: ModelContainer
    
    private var mainContext: ModelContext {
        container.mainContext
    }
    
    init() {
        self.container = try! ModelContainer(for: MovieEntity.self)
    }
    
    func getFavorites() throws -> [Movie] {
        let descriptor = FetchDescriptor<MovieEntity>(sortBy: [SortDescriptor(\.dateAdded, order: .reverse)])
        let entities = try mainContext.fetch(descriptor)
        return entities.map({ $0.toModel() })
    }
    
    func addToFavorites(movie: Movie) throws {
        let entity = MovieEntity(from: movie)
        mainContext.insert(entity)
        try mainContext.save()
    }
    
    func isFavorite(movie: Movie) throws -> Bool {
        let descriptor = FetchDescriptor<MovieEntity>(predicate: #Predicate { movieEntity in
            movieEntity.id == movie.id
        })
        let entities = try mainContext.fetch(descriptor)
        return !entities.isEmpty
    }
    
    func removeFavorite(movie: Movie) throws {
        let descriptor = FetchDescriptor<MovieEntity>(predicate: #Predicate { movieEntity in
            movieEntity.id == movie.id
        })
        let entities = try mainContext.fetch(descriptor)
        entities.forEach { movie in
            mainContext.delete(movie)
        }
    }
}
