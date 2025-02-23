//
//  TheatreLocationsPresenter.swift
//  TMDB VIPER
//
//  Created by Aleksandar Milidrag on 23. 2. 2025..
//

import SwiftUI
import MapKit

@MainActor
@Observable
class TheatreLocationsPresenter {
    
    let interactor: TheatreLocationsInteractor
    let router: TheatreLocationsRouter
    
    var cameraPosition: MapCameraPosition = .userLocation(fallback: .automatic)
    var location: CLLocation?
    var query: String = "movie theater"
    var region = MKCoordinateRegion()
    var authorizationStatus: CLAuthorizationStatus = .notDetermined
    var searchedLocations: [MKMapItem] = []
    
    init(interactor: TheatreLocationsInteractor, router: TheatreLocationsRouter) {
        self.interactor = interactor
        self.router = router
    }
    
    func getAuthorizationStatus() async {
        authorizationStatus = await interactor.getAuthorizationStatus()
    }
    
    func requestLocation() async {
        do {
            location = try await interactor.requestLocation()
        } catch {
            print(error)
        }
    }
    
    func requestRegion() async {
        guard let location else { return }
        region = MKCoordinateRegion(center: location.coordinate, span: .init(latitudeDelta: 0.01, longitudeDelta: 0.01))
    }
    
    func searchLocations(query: String, region: MKCoordinateRegion) async throws {
        searchedLocations = try await interactor.searchLocations(query: query, region: region)
    }
    
}
