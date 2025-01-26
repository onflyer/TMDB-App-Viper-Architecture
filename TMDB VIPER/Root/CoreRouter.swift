//
//  CoreRouter.swift
//  TMDB VIPER
//
//  Created by Aleksandar Milidrag on 22. 12. 2024.
//

import Foundation

@MainActor
struct CoreRouter {
    
    let router: Router
    let builder: CoreBuilder
    
    func showDetailView(delegate: DetailViewDelegate) {
        router.showScreen(.push) { router in
            builder.detailView(router: router, delegate: delegate)
        }
    }
    
    func showFavoritesView() {
        router.showScreen(.sheet) { router in
            builder.favoritesView(router: router)
        }
    }
    
    func showTrailerModalView(movie: SingleMovie, onXMarkPressed: @escaping () -> Void) {
        router.showModal(backgroundColor: .black.opacity(0.3), transition: .identity) {
            builder.trailerModalView(movie: movie, onDismiss: onXMarkPressed)
        }
    }
    
    func showImageModalView(urlString: String, onXMarkPressed: @escaping () -> Void) {
        router.showModal(backgroundColor: .black.opacity(0.3), transition: .scale) {
            
        }
    }
    
    func dismissModal() {
        router.dismissModal()
    }
    
    func dismissScreen() {
        router.dismissScreen()
    }
    

}
