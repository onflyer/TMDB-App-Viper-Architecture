//
//  CoreRouter.swift
//  TMDB VIPER
//
//  Created by Aleksandar Milidrag on 22. 12. 2024.
//

import Foundation
import SwiftUI

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
    
    func showTheatreLocationsView() {
        router.showScreen(.fullScreenCover) { router in
            builder.theatreLocationsView(router: router)
        }
    }
    
    func showTrailerModalView(movie: SingleMovie, onXMarkPressed: @escaping () -> Void) {
        router.showModal(backgroundColor: .black.opacity(0.3), transition: .identity) {
            builder.trailerModalView(movie: movie, onDismiss: onXMarkPressed)
        }
    }
    
    func showImageModalView(urlString: String, onXMarkPressed: @escaping () -> Void) {
        router.showModal(backgroundColor: .black.opacity(0.7), transition: .scale.combined(with: .opacity)) {
            builder.imageModalView(imageString: urlString, onDismiss: onXMarkPressed)
        }
    }
    
    func dismissModal() {
        router.dismissModal()
    }
    
    func dismissScreen() {
        router.dismissScreen()
    }
    

}
