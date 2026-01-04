//
//  TheatreLocationsViewController.swift
//  TMDB VIPER
//
//  Created by Aleksandar Milidrag on 22. 12. 2024..
//

import UIKit
import MapKit

// MARK: - TheatreLocationsViewController
/// The UIKit equivalent of your TheatreLocationsView.
///
/// SwiftUI uses Map view, UIKit uses MKMapView.
///
/// SwiftUI:
/// ```
/// Map(position: $presenter.cameraPosition) {
///     ForEach(presenter.searchedLocations) { place in
///         Marker(place.name, coordinate: place.coordinate)
///     }
///     UserAnnotation()
/// }
/// ```

class TheatreLocationsViewController: UIViewController {
    
    // MARK: - Properties
    
    private let presenter: TheatreLocationsPresenter
    
    // MARK: - UI Elements
    
    /// Map view showing nearby theaters.
    /// SwiftUI equivalent: Map(...)
    private lazy var mapView: MKMapView = {
        let mv = MKMapView()
        mv.translatesAutoresizingMaskIntoConstraints = false
        mv.delegate = self
        mv.showsUserLocation = true
        return mv
    }()
    
    /// Loading indicator while fetching location/theaters.
    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    // MARK: - Initialization
    
    init(presenter: TheatreLocationsPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavigationBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadTheatersNearby()
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(mapView)
        view.addSubview(loadingIndicator)
        
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
    
    private func setupNavigationBar() {
        title = "Theaters near you"
        navigationController?.navigationBar.prefersLargeTitles = false
        
        // Close button
        let closeButton = UIBarButtonItem(
            image: UIImage(systemName: "xmark"),
            style: .plain,
            target: self,
            action: #selector(closeTapped)
        )
        navigationItem.rightBarButtonItem = closeButton
    }
    
    // MARK: - Data Loading
    
    private func loadTheatersNearby() {
        loadingIndicator.startAnimating()
        
        Task {
            // Get authorization and location
            await presenter.getAuthorizationStatus()
            await presenter.requestLocation()
            await presenter.requestRegion()
            await presenter.searchLocations(query: presenter.query, region: presenter.region)
            
            await MainActor.run {
                loadingIndicator.stopAnimating()
                updateMap()
            }
        }
    }
    
    /// Update map with theater locations.
    /// SwiftUI does this automatically with @Observable.
    /// UIKit requires manual update.
    private func updateMap() {
        // Remove existing annotations
        mapView.removeAnnotations(mapView.annotations)
        
        // Set region centered on user location
        let region = MKCoordinateRegion(
            center: presenter.location.coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        )
        mapView.setRegion(region, animated: true)
        
        // Add theater annotations
        /// SwiftUI equivalent: ForEach(presenter.searchedLocations) { Marker(...) }
        for mapItem in presenter.searchedLocations {
            let annotation = MKPointAnnotation()
            annotation.coordinate = mapItem.placemark.coordinate
            annotation.title = mapItem.name ?? "Theater"
            annotation.subtitle = mapItem.placemark.title
            mapView.addAnnotation(annotation)
        }
        
        print("🎬 Added \(presenter.searchedLocations.count) theater locations to map")
    }
    
    // MARK: - Actions
    
    @objc private func closeTapped() {
        presenter.onXmarkPressed()
    }
}

// MARK: - MKMapViewDelegate
extension TheatreLocationsViewController: MKMapViewDelegate {
    
    /// Customize annotation view (map pins).
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        // Don't customize user location
        if annotation is MKUserLocation {
            return nil
        }
        
        let identifier = "TheaterAnnotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView
        
        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            annotationView?.markerTintColor = .systemRed
            annotationView?.glyphImage = UIImage(systemName: "film")
        } else {
            annotationView?.annotation = annotation
        }
        
        return annotationView
    }
}

// MARK: - SwiftUI vs UIKit Map Comparison
/*
 
 ┌─────────────────────────────────────────────────────────────────┐
 │              MAP COMPARISON                                     │
 ├─────────────────────────────────────────────────────────────────┤
 │                                                                 │
 │  SWIFTUI Map:                                                   │
 │  ────────────                                                   │
 │  Map(position: $cameraPosition) {                              │
 │      ForEach(locations) { place in                             │
 │          Marker(place.name, coordinate: place.coordinate)      │
 │      }                                                          │
 │      UserAnnotation()                                          │
 │  }                                                              │
 │  // Declarative - just describe what you want                  │
 │                                                                 │
 │                                                                 │
 │  UIKIT MKMapView:                                              │
 │  ────────────────                                              │
 │  // Setup                                                       │
 │  mapView.showsUserLocation = true                              │
 │  mapView.delegate = self                                       │
 │                                                                 │
 │  // Add markers manually                                        │
 │  for location in locations {                                   │
 │      let annotation = MKPointAnnotation()                      │
 │      annotation.coordinate = location.coordinate               │
 │      mapView.addAnnotation(annotation)                         │
 │  }                                                              │
 │                                                                 │
 │  // Customize appearance via delegate                          │
 │  func mapView(viewFor annotation:) -> MKAnnotationView? {     │
 │      // return custom view                                     │
 │  }                                                              │
 │                                                                 │
 ├─────────────────────────────────────────────────────────────────┤
 │                                                                 │
 │  KEY DIFFERENCES:                                               │
 │  - SwiftUI: Marker() component                                 │
 │  - UIKit: MKPointAnnotation + MKAnnotationView                 │
 │  - SwiftUI: Binding for camera position                        │
 │  - UIKit: setRegion() method                                   │
 │                                                                 │
 └─────────────────────────────────────────────────────────────────┘
 
 */
