//
//  LocationHelper.swift
//  Yeehaw
//
//  Created by Yotzin Castrejon on 4/7/21.
//

import Foundation
import CoreLocation
import UIKit

class LocationHelper: NSObject, ObservableObject, CLLocationManagerDelegate {
    let locationManager = CLLocationManager()
    
    private var askPermissionCallback: ((CLAuthorizationStatus) -> Void)?
    private var locationReceivedCallback: ((CLLocation) -> Void)?
    var trackedLocations = [CLLocation]()
    
    
    @Published var speed = "--"
    @Published var traveledDistanceString = "--"
    var distanceTraveled: Double = 0
    var lastLocation: CLLocation?
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
    
    
    //These two functions below were in the locationHelper delegate commented out below. I want to see whether or not it works.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        askPermissionCallback?(status)
        askPermissionCallback = nil
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
        updateLocationStatistics(location: location)
        }
        locationReceivedCallback?(locations.last!)
        trackedLocations += locations
    }
    
    // 1 mile = 5280 feet
    //    // Meter to miles = m * 0.00062137
    //    // 1 meter = 3.28084 feet
    //    // 1 foot = 0.3048 meters
    //    // km = m / 1000
    //    // m = km * 1000
    //    // ft = m / 3.28084
    //    // 1 mile = 1609 meters
    func updateLocationStatistics(location: CLLocation) {
        updateSpeed(metersPerSecond: location.speed)
        updateDistance(location: location)
        
        
    }
    
    func updateSpeed(metersPerSecond: Double) {
        if metersPerSecond < 0 {
            speed = "0"
        } else {
        //speed is in meters per second
        let feetPerSecond = metersPerSecond * 3.28083989501312
        let milesPerSecond = feetPerSecond / 5280
        let milesPerMinute = milesPerSecond * 60
        let milesPerHour = milesPerMinute * 60
        speed = String(format: "%0.1f",milesPerHour)
        }
    }
    
    func updateDistance(location: CLLocation) {
        if let last = lastLocation {
            //returns distance in meters
            distanceTraveled += last.distance(from: location)
            let feet = distanceTraveled * 3.28083989501312
            let miles = feet / 5280
            traveledDistanceString = String(format: "%0.2f", miles)
        }
        lastLocation = location
    }
    
    func startTracking() {
        locationManager.startUpdatingLocation()
    }
    
    func stopTracking() {
        locationManager.stopUpdatingLocation()
        resetVariables()
    }
    
    func resetVariables() {
        speed = "--"
        distanceTraveled = 0
        traveledDistanceString = "--"
    }
}

//extension LocationHelper: CLLocationManagerDelegate {
//
//}


//class TestViewController: UIViewController, CLLocationManagerDelegate {
//    //MARK: Global Var's
//    var locationManager: CLLocationManager = CLLocationManager()
//    var switchSpeed = "KPH"
//    var startLocation:CLLocation!
//    var lastLocation: CLLocation!
//    var traveledDistance:Double = 0
//    var arrayMPH: [Double]! = []
//    var arrayKPH: [Double]! = []
//
//    //MARK: IBoutlets
//    @IBOutlet weak var speedDisplay: UILabel!
//    @IBOutlet weak var headingDisplay: UILabel!
//    @IBOutlet weak var latDisplay: UILabel!
//    @IBOutlet weak var lonDisplay: UILabel!
//    @IBOutlet weak var distanceTraveled: UILabel!
//    @IBOutlet weak var minSpeedLabel: UILabel!
//    @IBOutlet weak var maxSpeedLabel: UILabel!
//    @IBOutlet weak var avgSpeedLabel: UILabel!
//
//    //MARK: Life Cycle
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        minSpeedLabel.text = "0"
//        maxSpeedLabel.text = "0"
//        // Ask for Authorisation from the User.
//        self.locationManager.requestAlwaysAuthorization()
//
//        // For use in foreground
//        self.locationManager.requestWhenInUseAuthorization()
//        if CLLocationManager.locationServicesEnabled() {
//            locationManager.delegate = self
//            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
//            locationManager.startUpdatingLocation()
//        }
//    }
//
//
//    // 1 mile = 5280 feet
//    // Meter to miles = m * 0.00062137
//    // 1 meter = 3.28084 feet
//    // 1 foot = 0.3048 meters
//    // km = m / 1000
//    // m = km * 1000
//    // ft = m / 3.28084
//    // 1 mile = 1609 meters
//    //MARK: Location
//    private func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        let location = locations.last
//        if (location!.horizontalAccuracy > 0) {
//            updateLocationInfo(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude, speed: location!.speed, direction: location!.course)
//        }
//        if lastLocation != nil {
//            traveledDistance += lastLocation.distance(from: locations.last!)
//            if switchSpeed == "MPH" {
//                if traveledDistance < 1609 {
//                    let tdF = traveledDistance / 3.28084
//                    distanceTraveled.text = (String(format: "%.1f Feet", tdF))
//                } else if traveledDistance > 1609 {
//                    let tdM = traveledDistance * 0.00062137
//                    distanceTraveled.text = (String(format: "%.1f Miles", tdM))
//                }
//            }
//            if switchSpeed == "KPH" {
//                if traveledDistance < 1609 {
//                    let tdMeter = traveledDistance
//                    distanceTraveled.text = (String(format: "%.0f Meters", tdMeter))
//                } else if traveledDistance > 1609 {
//                    let tdKm = traveledDistance / 1000
//                    distanceTraveled.text = (String(format: "%.1f Km", tdKm))
//                }
//            }
//        }
//        lastLocation = locations.last
//
//    }
//
//    func updateLocationInfo(latitude: CLLocationDegrees, longitude: CLLocationDegrees, speed: CLLocationSpeed, direction: CLLocationDirection) {
//        let speedToMPH = (speed * 2.23694)
//        let speedToKPH = (speed * 3.6)
//        let val = ((direction / 22.5) + 0.5);
//        var arr = ["N", "NNE", "NE", "ENE", "E", "ESE", "SE", "SSE", "S", "SSW", "SW", "WSW", "W", "WNW", "NW", "NNW"];
//        let dir = arr[Int(val.truncatingRemainder(dividingBy: 16))]
//        //lonDisplay.text = coordinateString(latitude, longitude: longitude)
//
//        lonDisplay.text = (String(format: "%.3f", longitude))
//        latDisplay.text = (String(format: "%.3f", latitude))
//        if switchSpeed == "MPH" {
//            // Chekcing if speed is less than zero or a negitave number to display a zero
//            if (speedToMPH > 0) {
//                speedDisplay.text = (String(format: "%.0f mph", speedToMPH))
//                arrayMPH.append(speedToMPH)
//                let lowSpeed = arrayMPH.min()
//                let highSpeed = arrayMPH.max()
//                minSpeedLabel.text = (String(format: "%.0f mph", lowSpeed!))
//                maxSpeedLabel.text = (String(format: "%.0f mph", highSpeed!))
//                avgSpeed()
//            } else {
//                speedDisplay.text = "0 mph"
//            }
//        }
//
//        if switchSpeed == "KPH" {
//            // Checking if speed is less than zero
//            if (speedToKPH > 0) {
//                speedDisplay.text = (String(format: "%.0f km/h", speedToKPH))
//                arrayKPH.append(speedToKPH)
//                let lowSpeed = arrayKPH.min()
//                let highSpeed = arrayKPH.max()
//                minSpeedLabel.text = (String(format: "%.0f km/h", lowSpeed!))
//                maxSpeedLabel.text = (String(format: "%.0f km/h", highSpeed!))
//                avgSpeed()
//                //                print("Low: \(lowSpeed!) - High: \(highSpeed!)")
//            } else {
//                speedDisplay.text = "0 km/h"
//            }
//        }
//
//        // Shows the N - E - S W
//        headingDisplay.text = "\(dir)"
//
//    }
//
//    func avgSpeed(){
//        if switchSpeed == "MPH" {
//            let speed:[Double] = arrayMPH
//            let speedAvg = speed.reduce(0, +) / Double(speed.count)
//            avgSpeedLabel.text = (String(format: "%.0f", speedAvg))
//            //print( votesAvg )
//        } else if switchSpeed == "KPH" {
//            let speed:[Double] = arrayKPH
//            let speedAvg = speed.reduce(0, +) / Double(speed.count)
//            avgSpeedLabel.text = (String(format: "%.0f", speedAvg))
//            //print( votesAvg
//        }
//    }
//
//    //MARK: Buttons
//    @IBOutlet weak var switchSpeedStatus: UIButton!
//    @IBAction func speedSwtich(sender: UIButton) {
//        if switchSpeed == "MPH" {
//            switchSpeed = "KPH"
//            switchSpeedStatus.setTitle("KPH", for: .normal)
//        } else if switchSpeed == "KPH" {
//            switchSpeed = "MPH"
//            switchSpeedStatus.setTitle("MPH", for: .normal)
//        }
//    }
//
//    @IBAction func restTripButton(sender: AnyObject) {
//        arrayMPH = []
//        arrayKPH = []
//        traveledDistance = 0
//        minSpeedLabel.text = "0"
//        maxSpeedLabel.text = "0"
//        headingDisplay.text = "None"
//        speedDisplay.text = "0"
//        distanceTraveled.text = "0"
//        avgSpeedLabel.text = "0"
//    }
//
//    @IBAction func startTrip(sender: AnyObject) {
//        locationManager.startUpdatingLocation()
//    }
//
//    @IBAction func endTrip(sender: AnyObject) {
//        locationManager.stopUpdatingLocation()
//    }
//}
