//
//  LocationManager2.swift
//  TMDB VIPER
//
//  Created by Aleksandar Milidrag on 22. 2. 2025..
//

import Foundation
import MapKit

@Observable
class LocationManager3 {
    
    let service: LocationService3
    
    init(service: LocationService3) {
        self.service = service
    }
    
    func getAuthorizationStatus() async -> CLAuthorizationStatus {
        await service.getAuthorizationStatus()
    }
    
    func requestLocation() async throws -> CLLocation {
        try await service.requestLocation()
    }
    
    func searchLocations(query: String, region: MKCoordinateRegion) async throws -> [MKMapItem] {
        try await service.searchLocations(query: query, region: region)
    }

    /// Continuous location updates — use `for await` to consume.
    /// Stops automatically when the loop exits or task is cancelled.
    ///
    /// Example usage:
    /// ```swift
    /// // In a presenter or view model:
    /// func startTracking() {
    ///     trackingTask = Task {
    ///         for await location in locationManager.streamLocations() {
    ///             // Update map pin, calculate distance, etc.
    ///             self.currentLocation = location
    ///         }
    ///         // Stream ended (error or manual stop)
    ///     }
    /// }
    ///
    /// func stopTracking() {
    ///     trackingTask?.cancel()  // Cancelling the task stops the stream
    /// }
    /// ```
    func streamLocations() -> AsyncStream<CLLocation> {
        service.streamLocations()
    }

    func stopStreamingLocations() {
        service.stopStreamingLocations()
    }
}
