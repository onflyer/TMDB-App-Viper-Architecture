import Foundation
import MapKit

enum LocationError: Error {
    case alreadyRequesting
    case denied
    case restricted
    case noLocationFound
}

final class LocationServiceProd3: NSObject, CLLocationManagerDelegate, LocationService3 {
    
    private let coreLocation = CLLocationManager()
    private var permissionContinuation: CheckedContinuation<CLAuthorizationStatus, Never>?
    private var locationContinuation: CheckedContinuation<CLLocation, Error>?
    private var isRequestingLocation = false
    
    override init() {
        super.init()
        coreLocation.delegate = self
        coreLocation.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func getAuthorizationStatus() async -> CLAuthorizationStatus {
        switch coreLocation.authorizationStatus {
        case .notDetermined:
            return await withCheckedContinuation { continuation in
                permissionContinuation = continuation
                coreLocation.requestWhenInUseAuthorization()
            }
        default:
            return coreLocation.authorizationStatus
        }
    }
    
    func requestLocation() async throws -> CLLocation {
        guard !isRequestingLocation else {
            throw LocationError.alreadyRequesting
        }
        
        isRequestingLocation = true
        
        return try await withCheckedThrowingContinuation { continuation in
            locationContinuation = continuation
            coreLocation.requestLocation()
        }
    }
    
    func searchLocations(query: String, region: MKCoordinateRegion) async throws -> [MKMapItem] {
        let request = MKLocalSearch.Request()
        request.region = region
        request.naturalLanguageQuery = query
        let response = try await MKLocalSearch(request: request).start()
        return response.mapItems
    }
    
    // MARK: - CLLocationManagerDelegate
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        permissionContinuation?.resume(returning: manager.authorizationStatus)
        permissionContinuation = nil
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        isRequestingLocation = false
        locationContinuation?.resume(throwing: error)
        locationContinuation = nil
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        isRequestingLocation = false
        
        guard let location = locations.last else {
            locationContinuation?.resume(throwing: LocationError.noLocationFound)
            locationContinuation = nil
            return
        }
        
        locationContinuation?.resume(returning: location)
        locationContinuation = nil
    }
}
