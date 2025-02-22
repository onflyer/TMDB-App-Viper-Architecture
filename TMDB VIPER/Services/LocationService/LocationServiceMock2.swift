//
//  LocationServiceMock2.swift
//  TMDB VIPER
//
//  Created by Aleksandar Milidrag on 22. 2. 2025..
//

import Foundation
import MapKit

struct LocationServiceMock2: LocationService2 {

    let authorizationStatus: CLAuthorizationStatus
    let location: CLLocationCoordinate2D

    var delegateEvents: AsyncStream<DelegateEvent>
    let delegateContinuation: AsyncStream<DelegateEvent>.Continuation

    init(authorizationStatus: CLAuthorizationStatus = .authorizedWhenInUse, location: CLLocationCoordinate2D = CLLocationCoordinate2D (
        latitude: 34.0522300, longitude: -118.2436800)) {
            self.authorizationStatus = authorizationStatus
            self.location = location
            var continuation: AsyncStream<DelegateEvent>.Continuation!
            self.delegateEvents = AsyncStream { cont in
                continuation = cont
            }
            self.delegateContinuation = continuation
      }
    
    
    func requestWhenInUseAuthorization() {
      self.delegateContinuation.yield(.didChangeAuthorization(self.authorizationStatus))
    }
    func requestLocation() {
      self.delegateContinuation.yield(
        .didUpdateLocations([
          CLLocation(
            latitude: self.location.latitude,
            longitude: self.location.longitude
          )
        ])
      )
    }
    
    func searchLocations(query: String, region: MKCoordinateRegion) async throws -> [MKMapItem] {
        return [MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: 37.37409110, longitude: -122.03100050))),
                MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: 37.38888760, longitude: -121.98307640))) ]
        
    }
}
