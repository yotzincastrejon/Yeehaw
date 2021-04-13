//
//  MapViewModel.swift
//  Yeehaw
//
//  Created by Yotzin Castrejon on 3/17/21.
//

import SwiftUI
import MapKit
import CoreLocation

// All Map Data Goes Here....

class MapViewModel: NSObject,ObservableObject,CLLocationManagerDelegate{
    
    @Published var mapView = MKMapView()
    
    // Region...
    @Published var region : MKCoordinateRegion!
    
    
    // Alert...
    @Published var permissionDenied = false
    
    // Map Type...
    @Published var mapType : MKMapType = .standard
    
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        
        // Checking Permissions...
        
        switch manager.authorizationStatus {
        case .denied:
            // Alert...
            permissionDenied.toggle()
        case .notDetermined:
            // Requesting....
            manager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse:
            // If Permissin Given...
            manager.requestLocation()
        default:
            ()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        // Error....
        print(error.localizedDescription)
    }
    
    // Getting user Region....
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let location = locations.last else{return}
        
        self.region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
        
        // Updating Map....
        self.mapView.setRegion(self.region, animated: true)
        
        // Smooth Animations...
        self.mapView.setVisibleMapRect(self.mapView.visibleMapRect, animated: true)
    }
}

