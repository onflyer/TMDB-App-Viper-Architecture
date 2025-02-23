//
//  TheatreLocationsView.swift
//  TMDB VIPER
//
//  Created by Aleksandar Milidrag on 23. 2. 2025..
//

import SwiftUI
import MapKit

struct TheatreLocationsView: View {
    
    @State var presenter: TheatreLocationsPresenter
    
    var body: some View {
        Map(position: $presenter.cameraPosition) {
            UserAnnotation()
        }
        .task {
            await presenter.getAuthorizationStatus()
        }
        .navigationTitle("Theaters near you")
    }
}

#Preview {
    let builder = CoreBuilder(interactor: CoreInteractor(container: DevPreview.shared.container()))
    RouterView { router in
        builder.theatreLocationsView(router: router)
    }
}
