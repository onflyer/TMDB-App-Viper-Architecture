import Foundation
import MapKit

enum LocationError: Error {
    case alreadyRequesting
    case denied
    case restricted
    case noLocationFound
}

// MARK: - Example 1: One-Shot with CheckedContinuation
// Use when: You need a single location (e.g., "where am I right now?")
// Pattern: One request → one response → done

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

    // MARK: - One-Shot Async Methods (CheckedContinuation)

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

    /// One-shot: Get current location once.
    /// Bridges CLLocationManagerDelegate → async/await using CheckedContinuation.
    /// The continuation is resumed exactly ONCE when the delegate fires.
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

    // These are no-ops — this class only does one-shot requests
    func streamLocations() -> AsyncStream<CLLocation> { AsyncStream { $0.finish() } }
    func stopStreamingLocations() {}

    // MARK: - CLLocationManagerDelegate (One-Shot)

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

// MARK: - Example 2: Continuous Streaming with AsyncStream
// Use when: You need live location updates (e.g., live map tracking, navigation)
// Pattern: One request → many responses over time → stop when cancelled

final class LocationServiceStreaming3: NSObject, CLLocationManagerDelegate, LocationService3 {

    private let coreLocation = CLLocationManager()
    private var permissionContinuation: CheckedContinuation<CLAuthorizationStatus, Never>?
    private var streamContinuation: AsyncStream<CLLocation>.Continuation?
    private var isStreaming = false

    override init() {
        super.init()
        coreLocation.delegate = self
        coreLocation.desiredAccuracy = kCLLocationAccuracyBest
    }

    // MARK: - Permission (same as one-shot)

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

    // One-shot is not supported in streaming service — use LocationServiceProd3 instead
    func requestLocation() async throws -> CLLocation {
        fatalError("Use LocationServiceProd3 for one-shot requests, or call streamLocations() and take the first value.")
    }

    func searchLocations(query: String, region: MKCoordinateRegion) async throws -> [MKMapItem] {
        let request = MKLocalSearch.Request()
        request.region = region
        request.naturalLanguageQuery = query
        let response = try await MKLocalSearch(request: request).start()
        return response.mapItems
    }

    // MARK: - Continuous Location Streaming (AsyncStream)

    /// Starts continuous location updates and returns an AsyncStream.
    /// Each time the device moves, the delegate yields a new CLLocation into the stream.
    /// The stream stops automatically when:
    ///   - The consumer cancels the Task (e.g., task.cancel())
    ///   - The for-await loop exits
    ///   - You call stopStreamingLocations() manually
    ///
    /// Usage:
    /// ```swift
    /// trackingTask = Task {
    ///     for await location in locationService.streamLocations() {
    ///         updateMapPin(location)
    ///     }
    /// }
    ///
    /// // Later, to stop:
    /// trackingTask?.cancel()
    /// ```
    func streamLocations() -> AsyncStream<CLLocation> {
        stopStreamingLocations()

        return AsyncStream { continuation in
            self.streamContinuation = continuation
            self.isStreaming = true

            continuation.onTermination = { @Sendable _ in
                Task { @MainActor in
                    self.coreLocation.stopUpdatingLocation()
                    self.isStreaming = false
                    self.streamContinuation = nil
                }
            }

            self.coreLocation.startUpdatingLocation()
        }
    }

    /// Manually stop streaming.
    func stopStreamingLocations() {
        if isStreaming {
            coreLocation.stopUpdatingLocation()
            streamContinuation?.finish()
            streamContinuation = nil
            isStreaming = false
        }
    }

    // MARK: - CLLocationManagerDelegate (Streaming)

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        permissionContinuation?.resume(returning: manager.authorizationStatus)
        permissionContinuation = nil
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // Error while streaming — finish the stream so the for-await loop exits
        streamContinuation?.finish()
        streamContinuation = nil
        isStreaming = false
        coreLocation.stopUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }

        // Yield every location update into the stream
        streamContinuation?.yield(location)
    }
}
