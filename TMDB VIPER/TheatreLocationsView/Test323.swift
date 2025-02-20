//
//  Test323.swift
//  TMDB VIPER
//
//  Created by Aleksandar Milidrag on 20. 2. 2025..
//

import SwiftUI
import MapKit

struct Test323: View {
    var manager = LocationServiceProd()
    @State private var cameraPosition: MapCameraPosition = .userLocation(fallback: .automatic)

    var body: some View {
        ZStack {
            Map(position: $cameraPosition) {
                UserAnnotation()
            }
        }
        .task {
//            updateCameraPosition()
            print(manager.region)
        }
    }
    
    func updateCameraPosition() {
        if let userLocation = manager.userLocation {
            let userRegion = MKCoordinateRegion(
                center: userLocation.coordinate,
                span: MKCoordinateSpan(
                    latitudeDelta: 0.15,
                    longitudeDelta: 0.15
                )
            )
            withAnimation {
                cameraPosition = .region(userRegion)
            }
        }
    }
}

#Preview {
    Test323()
}
