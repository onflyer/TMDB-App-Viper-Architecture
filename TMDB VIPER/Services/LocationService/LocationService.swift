//
//  LocationService.swift
//  TMDB VIPER
//
//  Created by Aleksandar Milidrag on 20. 2. 2025..
//

import MapKit

protocol LocationService {
    func searchLocations(query: String) async throws -> MKLocalSearch.Response
    func getUserLocation() async throws -> CLLocation?

}

protocol LocationService2 {
    func getAuthorizationStatus() -> CLAuthorizationStatus
    var delegateEvents: AsyncStream<DelegateEvent> { get }
    func requestWhenInUseAuthorization()
    func requestLocation()
}


