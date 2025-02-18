//
//  TheatreLocationsView.swift
//  TMDB VIPER
//
//  Created by Aleksandar Milidrag on 18. 2. 2025..
//

import SwiftUI
import MapKit

struct TheatreLocationsView: View {
    
    var service = CLLocationManager()
    var body: some View {
        Map(content: {
            UserAnnotation()
        })
            .task {
                service.requestWhenInUseAuthorization()
            }
    }
    
}

#Preview {
    TheatreLocationsView()
}
