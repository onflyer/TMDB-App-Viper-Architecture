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
            builder.detailView(router: router)
        }
    }

}
