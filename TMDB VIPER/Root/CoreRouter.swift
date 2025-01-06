//
//  CoreRouter.swift
//  TMDB VIPER
//
//  Created by Aleksandar Milidrag on 22. 12. 2024..
//

import Foundation

struct CoreRouter {
    
    let router: Router
    let builder: CoreBuilder
    
    func showDetailView(delegate: DetailViewDelegate) {
        router.showScreen(.push) { router in
            builder.detailView(router: router, delegate: delegate)
        }
    }
    
    func showTrailerModalView(movie: SingleMovie, onXMarkPressed: @escaping () -> Void) {
        router.showModal(backgroundColor: .black.opacity(0.3), transition: .identity) {
            builder.trailerModalView(movie: movie, onDismiss: onXMarkPressed)
        }
    }
    
    func dismissModal() {
        router.dismissModal()
    }
    

}
