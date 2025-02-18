//
//  TheatreLocationService.swift
//  TMDB VIPER
//
//  Created by Aleksandar Milidrag on 18. 2. 2025..
//

import Foundation
import MapKit

struct MapKitLocationService {
   
    let service: CLLocationManager
    
    init(service: CLLocationManager = CLLocationManager()) {
        self.service = service
        service.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func searchLocations(query: String) async throws -> MKLocalSearch.Response {
        
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = query
        let response = MKLocalSearch(request: request)
        let results = try await response.start()
        return results
    }
    
    
    
}
