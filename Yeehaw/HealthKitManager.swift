//
//  HealthKitManager.swift
//  Yeehaw
//
//  Created by Yotzin Castrejon on 4/7/21.
//

import Foundation
import HealthKit
import CoreLocation

final class HealthKitManager: ObservableObject {
    
    let healthStore = HKHealthStore()
    let workoutConfiguration = HKWorkoutConfiguration()
    var primaryBuilder: HKWorkoutBuilder?
    var workoutBuilder: HKWorkoutRouteBuilder?
    var valid = false
    var startDate: Date?
    var workoutStartDate: Date?
    var finishedWorkout: HKWorkout?
    
    let allHKObjectTypes = Set([
        HKObjectType.workoutType(),
        HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!,
        HKObjectType.quantityType(forIdentifier: .distanceCycling)!,
        HKObjectType.quantityType(forIdentifier: .heartRate)!,
        HKSeriesType.workoutRoute()
    ])
    
    init() {
        guard HKHealthStore.isHealthDataAvailable() else {
            print("Health Data is not available!")
            return
        }
        
        healthStore.requestAuthorization(toShare: self.allHKObjectTypes, read: self.allHKObjectTypes) { (success, error) in
            guard success else {
                print("Health Data authorization was rejected!")
                return
            }
        }
        
        workoutConfiguration.activityType = .cycling
        workoutConfiguration.locationType = .outdoor
        
        self.valid = true
    }
    
    func requestAuthorization() {
        healthStore.requestAuthorization(toShare: allHKObjectTypes, read: allHKObjectTypes) {
            (success, error) in
            //handle error
        }
    }
    
    func startSession(date: Date) -> Void {
        workoutBuilder = HKWorkoutRouteBuilder(healthStore: healthStore, device: .local())
        workoutStartDate = Date()
        self.primaryBuilder = HKWorkoutBuilder(
            healthStore: healthStore,
            configuration: workoutConfiguration,
            device: .local()
        )
        
        self.startDate = date
        primaryBuilder!.beginCollection(withStart: self.startDate!) { (success, error) in
            guard success else {
                print("Failed to beginCollection")
                return
            }
        }
    }
    
    func appendWorkoutData(_ location: CLLocation) {
        workoutBuilder?.insertRouteData([location]) { success, error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                print("Location data added to route")
            }
        }
    }
    
//    func addWorkoutEventSample() {
//        
//    }
    
    func addDistanceSample(_ distance: Double) {
        
        let time = Date()
        let sample = HKCumulativeQuantitySample(
            type: HKObjectType.quantityType(forIdentifier: .distanceCycling)!,
            quantity: HKQuantity(unit: HKUnit.meter(), doubleValue: distance),
            start: time,
            end: time
        )
        
        self.primaryBuilder!.add([sample]) { (success, error) in
            guard success else {
                print("failed to get add")
                return
            }
        }
    }
    
    func addHeartRateSample(_ heartrate: Double) {
        
        let time = Date()
        let sample = HKCumulativeQuantitySample(
            type: HKObjectType.quantityType(forIdentifier: .heartRate)!,
            quantity: HKQuantity(unit: HKUnit.count().unitDivided(by: HKUnit.minute()), doubleValue: heartrate),
            start: time,
            end: time
        )
        
        self.primaryBuilder!.add([sample]) { (success, error) in
            guard success else {
                print("failed to get add")
                return
            }
        }
    }
    

    
    func finishSession() {
        
        primaryBuilder!.endCollection(withEnd: Date()) { (success, error) in
            guard success else {
                print("failed to endCollection")
                return
            }
        }
        
        
        primaryBuilder!.finishWorkout { (workout, error) in
            guard workout != nil else {
                print("failed to finishWorkout")
                return
            }
            self.finishedWorkout = workout
            //use that finishedowrkout as your HKWorkout object to use finishroute.
            
            guard let builder = self.workoutBuilder, let startDate = self.workoutStartDate
            else { return }
            
            let workout = HKWorkout(activityType: .cycling, start: startDate, end: Date())
            
            
            builder.finishRoute(with: self.finishedWorkout ?? workout, metadata: [ : ]) { route, error in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    print("route saved: \(route.debugDescription)")
                }
            }
        }
    }
    
    
}
