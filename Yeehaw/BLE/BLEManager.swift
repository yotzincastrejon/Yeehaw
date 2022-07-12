//
//  BLEManager.swift
//  Yeehaw
//
//  Created by Yotzin Castrejon on 3/30/21.
//

import Foundation
import CoreBluetooth
import Combine

let speedCadenceServiceCBUUID = CBUUID(string: "0x1816")
let speedCadenceCSCMeasurementCBUUID = CBUUID(string: "2A5B")
let speedCadenceCSCFeatureCBUUID = CBUUID(string: "2A5C")
let heartRateServiceCBUUID = CBUUID(string: "0x180D")
let heartRateMeasurementCharacteristicCBUUID = CBUUID(string: "2A37")
let bodySensorLocationCharacteristicCBUUID = CBUUID(string: "2A38")

// MARK: - Bluetooth Manager
class BLEManager: NSObject, ObservableObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    
    var centralManager: CBCentralManager!
    var devicePeripheral: CBPeripheral!
    let arrayService = [heartRateServiceCBUUID, speedCadenceServiceCBUUID]
    let idArray = ["45CC5C66-FD7D-C7C9-5650-BF4727BDA7CD", "A7DBA197-EF45-A8E5-17FB-DF8505493179"]
    @Published var bodySensorLocationLabel = ""
    @Published var heartRateLabel = "--"
    @Published var speedLabel = "--"
    @Published var cadenceLabel = "--"
    @Published var peripherals = [Peripheral]()
    @Published var saved = [Saved]()
    @Published var heartRateIsConnected: Bool = false
    @Published var speedSensorIsConnected: Bool = false
    @Published var isConnected: Bool = false
    @Published var heartRateNumber = 0
    @Published var distanceRateinMeters = 0.0
    @Published var isScanning = false
    @Published var sensorsArrayDeviceID = [String]()
    var oldWheelRev = 0
    var newWheelRev = 0
    var oldWheelEvent = 0.0
    var newWheelEvent = 0.0
    var oldCrankRev = 0
    var newCrankRev = 0
    var oldCrankEvent = 0.0
    var newCrankEvent = 0.0
    let wheelCircumference = 2.155
    var areStopped = 0
    var crankStopped = 0
    @Published var wheelupdated = 0
    var crankupdated = 0
    var distanceTraveled = 0.0
    var devicesConnected = 0
    var passes = 0
    @Published var heartRateSensor = Peripheral(name: "", rssi: 0, uid: UUID())
    @Published var heartRateSensorState: Bool = false
    @Published var speedAndCadenceSensor = Peripheral(name: "", rssi: 0, uid: UUID())
    @Published var speedAndCadenceSensorState: Bool = false
    @Published var powerMeter = Peripheral(name: "", rssi: 0, uid: UUID())
    @Published var powerMeterState: Bool = false
    @Published var readyToBeScanned = false
    //    var distanceinRaw = 0
    override init() {
        super.init()
        
        centralManager = CBCentralManager(delegate: self, queue: nil)
        centralManager.delegate = self
        if let heartSensorName = UserDefaults.standard.string(forKey: "Heart Rate Sensor Name") {
            if let heartSensorUUID = UserDefaults.standard.string(forKey: "Heart Rate Sensor UUID") {
                heartRateSensor = Peripheral(name: heartSensorName, rssi: 0, uid: UUID(uuidString: heartSensorUUID)!)
            }
        }
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .unknown:
            print("central.state is .unknown")
        case .resetting:
            print("central.state is .resetting")
        case .unsupported:
            print("central.state is .unsupported")
        case .unauthorized:
            print("central.state is .unauthorized")
        case .poweredOff:
            print("central.state is .poweredOff")
        case .poweredOn:
            print("central.state is .poweredOn")
            readyToBeScanned.toggle()
        @unknown default:
            print("It went to unknown default")
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral,
                        advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if passes == 0 {
            sensorsArrayDeviceID.removeAll()
        }
        passes += 1
        print("Passes: \(passes)")
        print("Raw Peripheral: \(peripheral)")
        //        print("Peripheral Name: \(peripheral.name)")
        print("Peripheral State: \(peripheral.state)")
        devicePeripheral = peripheral
        devicePeripheral.delegate = self
        //part of original code
        //        centralManager.stopScan()
        //        if devicesConnected == 2 {
        //            centralManager.stopScan()
        //        }
        
        // We need to go through each peripheral and match it to our default.
        if peripheral.identifier == heartRateSensor.uid || peripheral.identifier == speedAndCadenceSensor.uid || peripheral.identifier == powerMeter.uid{
            centralManager.stopScan()
            centralManager.connect(peripheral)
        } else {
            var peripheralName: String!
            
            if let name = advertisementData[CBAdvertisementDataLocalNameKey] as? String {
                peripheralName = name
            } else {
                peripheralName = "Unknown"
            }
            let newPeripheral = Peripheral(name: peripheralName, rssi: RSSI.intValue, uid: peripheral.identifier)
            print("new Peripheral: \(newPeripheral)")
            if !sensorsArrayDeviceID.contains(newPeripheral.uid.description){
                
                peripherals.append(newPeripheral)
            }
        }
        
        
        
        //This bool is to create a layer between adding a sensor and connecting to said device. The reason why we are going to do this through here is because when you already have a homescreen with your given sensors, you will automatically connect. But I don't want automatically connect while doing the initial setup. Once we add the UUID's we want. We will automatically connect on the home screen.
        //        if isScanning {
        //            //do nothing
        //        } else {
        //        centralManager.connect(heartRatePeripheral)
        //        }
        // part of original code
        //        centralManager.scanForPeripherals(withServices: [heartRateServiceCBUUID,speedCadenceServiceCBUUID])
        
        //        if !saved.isEmpty {
        //        //heart rate array place
        //        if peripheral.identifier == saved[0].id {
        //            centralManager.connect(devicePeripheral)
        //            heartRateIsConnected = true
        //            devicesConnected = devicesConnected + 1
        //        }
        //        }
        //
        //        if saved.count > 1 {
        //        //speed sensor default place
        //        if peripheral.identifier == saved[1].id {
        //            centralManager.connect(devicePeripheral)
        //            speedSensorIsConnected = true
        //            devicesConnected = devicesConnected + 1
        //        }
        //        }
        
        
        //                centralManager.connect(heartRatePeripheral)
    }
    
    
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Connected!")
        //Once connected there needs to be a function here that will show that the peripheral is connected
        devicePeripheral.discoverServices([heartRateServiceCBUUID, speedCadenceServiceCBUUID])
        
        if peripheral.identifier == heartRateSensor.uid {
            heartRateSensorState = true
        }
        if peripheral.identifier == speedAndCadenceSensor.uid {
            speedAndCadenceSensorState = true
        }
        if peripheral.identifier == powerMeter.uid {
            powerMeterState = true
        }
        //if you connected to heart rate, then scan for speed cadence
        //        if peripheral.identifier == saved[0].id {
        //            heartRateIsConnected = true
        //            if !speedSensorIsConnected {
        //                centralManager.scanForPeripherals(withServices: [speedCadenceServiceCBUUID])
        //            }
        //        }
        
        
        // if you found your speed sensor great! But check just incase you found speed sensor first before heart rate. If heart rate wasn't found try to scan for it again.
        //        if peripheral.identifier == saved[1].id {
        //            speedSensorIsConnected = true
        //            if !heartRateIsConnected {
        //                centralManager.scanForPeripherals(withServices: [heartRateServiceCBUUID])
        //            }
        //        }
    }
    
    // MARK: - Peripheral Manager
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services else { return }
        for service in services {
            print(service)
            peripheral.discoverCharacteristics(nil, for: service)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard let characteristics = service.characteristics else { return }
        
        for characteristic in characteristics {
            print(characteristic)
            
            if characteristic.properties.contains(.read) {
                print("\(characteristic.uuid): properties contains .read")
                peripheral.readValue(for: characteristic)
            }
            if characteristic.properties.contains(.notify) {
                print("\(characteristic.uuid): properties contains .notify")
                peripheral.setNotifyValue(true, for: characteristic)
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        switch characteristic.uuid {
        case bodySensorLocationCharacteristicCBUUID:
            let bodySensorLocation = bodyLocation(from: characteristic)
            bodySensorLocationLabel = bodySensorLocation
        case heartRateMeasurementCharacteristicCBUUID:
            let bpm = heartRate(from: characteristic)
            onHeartRateReceived(bpm)
        case speedCadenceCSCFeatureCBUUID:
            print(characteristic)
        case speedCadenceCSCMeasurementCBUUID:
            speedRate(characteristic: characteristic)
        default:
            print("Unhandled Characteristic UUID: \(characteristic.uuid)")
        }
    }
    
    // MARK: - Heart Rate Functions
    func onHeartRateReceived(_ heartRate: Int) {
        heartRateLabel = "\(String(heartRate))"
        heartRateNumber = heartRate
        print("BPM: \(heartRate)")
    }
    private func bodyLocation(from characteristic: CBCharacteristic) -> String {
        guard let characteristicData = characteristic.value,
              let byte = characteristicData.first else { return "Error" }
        
        switch byte {
        case 0: return "Other"
        case 1: return "Chest"
        case 2: return "Wrist"
        case 3: return "Finger"
        case 4: return "Hand"
        case 5: return "Ear Lobe"
        case 6: return "Foot"
        default:
            return "Reserved for future use"
        }
    }
    
    private func heartRate(from characteristic: CBCharacteristic) -> Int {
        guard let characteristicData = characteristic.value else { return -1 }
        let byteArray = [UInt8](characteristicData)
        // See: https://www.bluetooth.com/specifications/gatt/viewer?attributeXmlFile=org.bluetooth.characteristic.heart_rate_measurement.xml
        // The heart rate mesurement is in the 2nd, or in the 2nd and 3rd bytes, i.e. one one or in two bytes
        // The first byte of the first bit specifies the length of the heart rate data, 0 == 1 byte, 1 == 2 bytes
        let firstBitValue = byteArray[0] & 0x01
        if firstBitValue == 0 {
            // Heart Rate Value Format is in the 2nd byte
            return Int(byteArray[1])
        } else {
            // Heart Rate Value Format is in the 2nd and 3rd bytes
            return (Int(byteArray[1]) << 8) + Int(byteArray[2])
        }
    }
    
    private func speedRate(characteristic: CBCharacteristic) {
        let value = characteristic.value
        let result = CSCData(data: value!)
        
        
        //                print("crank revolutions:\(result?.crankRevolutions)")
        /// - Tag: Crank Cadence Calulation
        oldCrankRev = newCrankRev
        newCrankRev = (result?.crankRevolutions!.revolutions)!
        oldCrankEvent = newCrankEvent
        newCrankEvent = (result?.crankRevolutions!.eventTime)!
        let differenceCrankRev = newCrankRev - oldCrankRev
        var differenceCrankEvent = newCrankEvent - oldCrankEvent
        if oldCrankEvent > newCrankEvent {
            differenceCrankEvent = (64 + newCrankEvent) - oldCrankEvent
        }
        let crankRevLet = Double(differenceCrankRev) / differenceCrankEvent
        let crankRpm = crankRevLet * 60
        if oldCrankEvent == newCrankEvent && oldCrankRev == newCrankRev {
            //            print("Crank hasn't moved")
            crankStopped = crankStopped + 1
            if crankStopped >= 4 {
                cadenceLabel = "0"
            }
            crankupdated = crankupdated + 1
        } else {
            if crankupdated > 4 {
                cadenceLabel = "\(String(format: "%.0f", crankRpm))"
            }
            crankStopped = 0
            crankupdated = crankupdated + 1
        }
        
        //        print("wheel revolutions:\(result?.wheelRevolutions)")
        /// - Tag: Speed Calculation from Wheel
        oldWheelRev = newWheelRev
        newWheelRev = (result?.wheelRevolutions!.revolutions)!
        oldWheelEvent = newWheelEvent
        newWheelEvent = (result?.wheelRevolutions!.eventTime)!
        let differenceRev = newWheelRev - oldWheelRev
        var differenceEvent = newWheelEvent - oldWheelEvent
        if oldWheelEvent > newWheelEvent {
            differenceEvent = (64 + newWheelEvent) - oldWheelEvent
        }
        let revLet = Double(differenceRev) / differenceEvent
        let wheelRpm = revLet * 60
        let metersTraveled = wheelRpm * wheelCircumference
        let metersPerHour = metersTraveled * 60
        let milesPerHour = metersPerHour * (1/1609.344)
        let distance = revLet * wheelCircumference
        //we're going to pass raw distance on so we can use it in other places.
        //        print("raw distance from BLEManageR: \(distance)")
        distanceRateinMeters = distance
        //if the wheel stopped moving count the number of times you are stopped as to update the speed label to 0
        if newWheelEvent == oldWheelEvent && newWheelRev == oldWheelRev {
            //            print("nothing has changed")
            areStopped = areStopped + 1
            if areStopped >= 4 {
                speedLabel = "0"
            }
            wheelupdated = wheelupdated + 1
        } else {
            speedLabel = String(format: "%.2f", milesPerHour)
            areStopped = 0
            wheelupdated = wheelupdated + 1
            
        }
        
        print("wheel updated: \(wheelupdated)")
    }
    
    // MARK: - Custom Functions
    func startScanning() {
        print("Started Scanning")
        centralManager.scanForPeripherals(withServices: [heartRateServiceCBUUID, speedCadenceServiceCBUUID])
        isScanning = true
    }
    
    func heartRateScan() {
        print("Scanning for Heart Rate Monitors")
        centralManager.scanForPeripherals(withServices: [heartRateServiceCBUUID])
    }
    
    func speedAndCadenceScan() {
        print("Scanning for speed and cadence sensors")
        centralManager.scanForPeripherals(withServices: [speedCadenceServiceCBUUID])
    }
    
    func powerMeterScan() {
        print("Scanning for power meters")
    }
    
    func stopScanning() {
        print("Stopped Scanning")
        centralManager.stopScan()
        isScanning = false
        peripherals.removeAll()
    }
    
    
    //⬆︎⬆︎⬆︎⬆︎The end of the functions add above this line ⬆︎⬆︎⬆︎⬆︎
    
}

// MARK: - Speed and Cadence Sensor Functions
extension Data {
    // Based on Martin R's work: https://stackoverflow.com/a/38024025/97337
    mutating func consume<T>(type: T.Type) -> T? where T: ExpressibleByIntegerLiteral {
        let valueSize = MemoryLayout<T>.size
        guard count >= valueSize else { return nil }
        var value: T = 0
        _ = Swift.withUnsafeMutableBytes(of: &value, { copyBytes(to: $0)} )
        removeFirst(valueSize)
        return value
    }
}


struct CSCData {
    var wheelRevolutions: RevolutionData?
    var crankRevolutions: RevolutionData?
    
    init?(data: Data) {
        
        var data = data // Make mutable so we can consume it
        
        // First pull off the flags
        guard let flags = Flags(consuming: &data) else { return nil }
        
        // If wheel revolution is present, decode it
        if flags.contains(.wheelRevolutionPresent) {
            guard let value = RevolutionData(consuming: &data, countType: UInt32.self) else {
                return nil
            }
            self.wheelRevolutions = value
        }
        
        // If crank revolution is present, decode it
        if flags.contains(.wheelRevolutionPresent) {
            guard let value = RevolutionData(consuming: &data, countType: UInt16.self) else {
                return nil
            }
            self.crankRevolutions = value
        }
        
        // You may or may not want this. Left-over data suggests that there was an error
        if !data.isEmpty {
            return nil
        }
    }
}

struct Flags : OptionSet {
    let rawValue: UInt8
    
    static let wheelRevolutionPresent = Flags(rawValue: 1 << 0)
    static let crankRevolutionPresent = Flags(rawValue: 1 << 1)
}

extension Flags {
    init?(consuming data: inout Data) {
        guard let byte = data.consume(type: UInt8.self) else { return nil }
        self.init(rawValue: byte)
    }
}

struct RevolutionData {
    var revolutions: Int
    var eventTime: TimeInterval
    
    init?<RevolutionCount>(consuming data: inout Data, countType: RevolutionCount.Type)
    where RevolutionCount: FixedWidthInteger
    {
        guard let count = data.consume(type: RevolutionCount.self)?.littleEndian,
              let time = data.consume(type: UInt16.self)?.littleEndian
        else {
            return nil
        }
        
        self.revolutions = Int(clamping: count)
        self.eventTime = TimeInterval(time) / 1024.0    // Unit is 1/1024 second
    }
}


// MARK: - Peripheral and Saved Structs
struct Peripheral: Identifiable {
    let id = UUID()
    let name: String
    let rssi: Int
    let uid: UUID
}

struct Saved: Identifiable, Equatable, Codable {
    let id: UUID
    let name: String
}
