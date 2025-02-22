//
//  LocationServiceProd2.swift
//  TMDB VIPER
//
//  Created by Aleksandar Milidrag on 22. 2. 2025..
//

import Foundation
import MapKit

final class LocationServiceProd2: NSObject, LocationService2 {
    let service = CLLocationManager()
    let delegateEvents: AsyncStream<DelegateEvent>
    var delegateEventsContinuation: AsyncStream<DelegateEvent>.Continuation
    
    override init() {
        var continuation: AsyncStream<DelegateEvent>.Continuation!
        self.delegateEvents = AsyncStream { cont in
            continuation = cont
        }
        self.delegateEventsContinuation = continuation
        super.init()
        self.service.delegate = self
    }
    
    var authorizationStatus: CLAuthorizationStatus {
        service.authorizationStatus
    }
    
    func requestWhenInUseAuthorization() {
        service.requestWhenInUseAuthorization()
    }
    
    func requestLocation() {
        service.requestLocation()
    }
}

//MARK: Delegate functions
extension LocationServiceProd2: CLLocationManagerDelegate {
    
    func locationManagerDidChangeAuthorization(_ service: CLLocationManager) {
        self.delegateEventsContinuation.yield(
            .didChangeAuthorization(service.authorizationStatus)
        )
    }
    
    func locationManager(_ service: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.delegateEventsContinuation.yield(
            .didUpdateLocations(locations)
        )
    }
    
    func locationManager(_ service: CLLocationManager, didFailWithError error: Error) {
        self.delegateEventsContinuation.yield(.didFail(error))
    }
}

enum DelegateEvent {
    case didChangeAuthorization(CLAuthorizationStatus)
    case didFail(Error)
    case didUpdateLocations([CLLocation])
}
