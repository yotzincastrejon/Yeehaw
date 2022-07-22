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
    @Published var elevationGainString = "--"
    @Published var elevationSlope = "--"
    @Published var courseDegrees = "--"
    @Published var windSpeed = 0.0
    @Published var degrees = 0.0
    var distanceTraveled: Double = 0
    var elevationGain: Double = 0
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
        updateElevation(location: location)
        //expressed in degrees
        courseDegrees = String(format: "%0.2f",location.course)
        
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
    
    func updateElevation(location: CLLocation) {
        if let last = lastLocation {
            if distanceTraveled > 0 {
            let rise = location.altitude - last.altitude
            let run = distanceTraveled
            let slope = rise / run
            elevationSlope = String(format: "%0.1f", slope)
            }
            if location.altitude > last.altitude {
                let meters = location.altitude - last.altitude
                let feet = meters * 3.28083989501312
                elevationGain += feet
                elevationGainString = String(Int(elevationGain))
                print(elevationGain)
            }
        }
    }
    
    func startTracking() {
        locationManager.startUpdatingLocation()
        windRequest()
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
    
    func getWindSpeed() {
        windRequest()
    }
    
    func windRequest() {
        
        if let location = locationManager.location {
            let lat = location.coordinate.latitude.description
            let lon = location.coordinate.longitude.description
            print("lat \(lat)")
            print("lon \(lon)")
        
        let apiKey = "04c7f638d81d7019d5057bf23c6586c9"
        
        let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=\(apiKey)")
        
        let task = URLSession.shared.dataTask(with: url!) { [self] data, response, error in
            guard let safeData = data,
                  let response = response as? HTTPURLResponse,
                  error == nil else {                                              // check for fundamental networking error
                      print("error", error ?? "Unknown error")

                      return
                  }

            guard (200 ... 299) ~= response.statusCode else {                    // check for http errors
                print("statusCode should be 2xx, but is \(response.statusCode)")
                print("response = \(response)")
                return
            }
            do {
                let response = try JSONDecoder().decode(Weather.self, from: safeData)
                
                DispatchQueue.main.async { [self] in
                    //m/s
                    windSpeed = response.wind?.speed ?? 0
                    //degress from 360
                    degrees = response.wind?.deg ?? 0
                }
                print(response.dt)
                
            } catch {
                print(error.localizedDescription)
                print(String(describing: error))
            }
        }
        task.resume()
        }
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






struct Weather: Codable {
    let coord: Coord?
    let weather: [WeatherElement]?
    let base: String?
    let main: Main?
    let visibility: Double?
    let wind: Wind?
    let clouds: Clouds?
    let dt: Double?
    let sys: Sys?
    let timezone, id: Double?
    let name: String?
    let cod: Double?
}

// MARK: - Clouds
struct Clouds: Codable {
    let all: Double?
}

// MARK: - Coord
struct Coord: Codable {
    let lon, lat: Double?
}

// MARK: - Main
struct Main: Codable {
    let temp, feelsLike, tempMin, tempMax: Double?
    let pressure, humidity, seaLevel, grndLevel: Double?

    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure, humidity
        case seaLevel = "sea_level"
        case grndLevel = "grnd_level"
    }
}

// MARK: - Sys
struct Sys: Codable {
    let type, id: Double?
    let country: String?
    let sunrise, sunset: Double?
}

// MARK: - WeatherElement
struct WeatherElement: Codable {
    let id: Double?
    let main, weatherDescription, icon: String?

    enum CodingKeys: String, CodingKey {
        case id, main
        case weatherDescription = "description"
        case icon
    }
}

// MARK: - Wind
struct Wind: Codable {
    let speed: Double?
    let deg: Double?
    let gust: Double?
}
