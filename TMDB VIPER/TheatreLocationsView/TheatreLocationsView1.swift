//
//  TheatreLocationsView.swift
//  TMDB VIPER
//
//  Created by Aleksandar Milidrag on 18. 2. 2025..
//

import SwiftUI
import MapKit

struct TheatreLocationsView1: View {
    
    @State private var position: MapCameraPosition = .userLocation(followsHeading: false, fallback: .automatic)
    @State private var visibleRegion: MKCoordinateRegion?
    @State private var bounds: MapCameraBounds = .init(minimumDistance: 50000, maximumDistance: 80000)
    @State private var mapItems: [MKMapItem] = []
    @Namespace private var mapScope

    var service = CLLocationManager()
    
    
    var body: some View {
        
        Map(position: $position, bounds: bounds) {
            ForEach(mapItems, id: \.self) { place in
                Marker(place.placemark.description, coordinate: place.placemark.coordinate)
            }
            
            UserAnnotation()
        }
       
    
        .onMapCameraChange { context in
            visibleRegion = context.region
            Task {
                try? await searchLocations()

            }
            
            print(mapItems)
        }
        .task {
            Task {
                try await Task.sleep(for: .seconds(1))
                bounds = .init(minimumDistance: 0.1, maximumDistance: 50000)
            }
            service.requestWhenInUseAuthorization()
            print(mapItems)
        }
    }
    
    func searchLocations() async throws {
        
        let request = MKLocalSearch.Request()
        request.region = visibleRegion ?? MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 48.884134, longitude: 2.332196), latitudinalMeters: 50000, longitudinalMeters: 50000)
        request.naturalLanguageQuery = "movie theater"
        let response = MKLocalSearch(request: request)
        let results = try await response.start()
        mapItems = results.mapItems
    }
    
    
}

#Preview {
    TheatreLocationsView1()
}
