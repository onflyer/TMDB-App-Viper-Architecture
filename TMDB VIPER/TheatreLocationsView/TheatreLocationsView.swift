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
        Map(position: $presenter.cameraPosition, bounds: MapCameraBounds(minimumDistance: 50000, maximumDistance: 100000)) {
            ForEach(presenter.searchedLocations, id: \.self) { place in
                Marker(place.placemark.description, coordinate: place.placemark.coordinate)
            }
            UserAnnotation()
            
        }
        .toolbar(content: {
            ToolbarItem(placement: .topBarTrailing) {
                Image(systemName: "xmark")
                    .tappableBackground()
                    .anyButton {
                        presenter.onXmarkPressed()
                    }
            }
        })
        .task {
            await presenter.getAuthorizationStatus()
            await presenter.requestLocation()
            await presenter.requestRegion()
            await presenter.searchLocations(query: presenter.query, region: presenter.region)
            print(presenter.searchedLocations)
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
