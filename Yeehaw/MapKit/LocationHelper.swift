//
//  LocationHelper.swift
//  Yeehaw
//
//  Created by Yotzin Castrejon on 4/7/21.
//

import Foundation
import CoreLocation

class LocationHelper: NSObject, ObservableObject {
    let locationManager = CLLocationManager()
    
    private var askPermissionCallback: ((CLAuthorizationStatus) -> Void)?
    private var locationReceivedCallback: ((CLLocation) -> Void)?
    var trackedLocations = [CLLocation]()
    override init() {
        super.init()
        
        locationManager.delegate = self
        locationManager.allowsBackgroundLocationUpdates = true
    }
    
    func requestAuthorization() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization()
    }
    
    func beginTrackingLocation(_ locationReceived: @escaping (CLLocation) -> Void) {
        if let location = trackedLocations.last {
            locationReceived(location)
        }
        
        self.locationReceivedCallback = locationReceived
        locationManager.startUpdatingLocation()
    }
    
    func stopTrackingLocation() {
        locationManager.stopUpdatingLocation()
        locationReceivedCallback = nil
    }
}

extension LocationHelper: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        askPermissionCallback?(status)
        askPermissionCallback = nil
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationReceivedCallback?(locations.last!)
        trackedLocations += locations
    }
}
