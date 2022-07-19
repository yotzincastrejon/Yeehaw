//
//  SensorDeviceConnectionView.swift
//  Yeehaw
//
//  Created by Yotzin Castrejon on 7/6/22.
//

import SwiftUI

struct SensorDeviceConnectionView: View {
    @ObservedObject var bleManager: BLEManager
    @Binding var sensorType: SensorType?
    @Binding var showSheet: Bool
    @State var peripheral: Peripheral?
    @Binding var isSensorConnected: Bool
    var body: some View {
        NavigationView {
            VStack {
                List {
                    if peripheral?.name != "" {
                        Section {
                            ZStack {
                            Rectangle()
                                .fill(Color(uiColor: .secondarySystemGroupedBackground))
                            HStack {
                                Text(peripheral?.name ?? "No Default Device")
                                Spacer()
                                Text(isSensorConnected ? "Connected" : "Not Connected")
                                    .foregroundColor(.secondary)
                            }
                        }
                        .cornerRadius(20)
                    .padding(.horizontal)
                        }
                    header: {
                       Text("My Devices")
                }
                    }
                    
                    Section {
                        ForEach(bleManager.peripherals) { device in
                            HStack {
                                Text(device.name)
                                Spacer()
                                RSSISignalStrength(rssiSignal: device.rssi)
                            }
                            .onTapGesture {
                                // Do Something change the default to this
                                saveSensorToDefaults(device: device)
                                retrieveDefaultDevice()
                            }
                        }
                    } header: {
                        HStack {
                            Text("Other Devices")
                            if bleManager.isScanning {
                                ProgressView()
                                    .padding(.leading, 4)
                            }
                        }
                    }
                }
                .listStyle(InsetGroupedListStyle())
                
            }
            .navigationTitle("\(sensorType?.description ?? "No Name") Sensor")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        // Do Something
                        showSheet.toggle()
                    } label: {
                        Text("Done")
                    }

                }
            }
            .task {
                scanForSensor()
                retrieveDefaultDevice()
            }
            .onDisappear {
                bleManager.stopScanning()
            }
        }
    }
    
    func scanForSensor() {
        switch sensorType {
        case .heartRate:
            bleManager.heartRateScan()
        case .speedAndCadence:
            bleManager.speedAndCadenceScan()
        case .power:
            bleManager.powerMeterScan()
        default:
            bleManager.startScanning()
        }
    }
    
    func saveSensorToDefaults(device: Peripheral) {
        switch sensorType {
        case .heartRate:
            UserDefaults.standard.set(device.name, forKey: "Heart Rate Sensor Name")
            UserDefaults.standard.set(device.uid.uuidString, forKey: "Heart Rate Sensor UUID")
            bleManager.heartRateSensor = device
        case .speedAndCadence:
            UserDefaults.standard.set(device.name, forKey: "Speed and Cadence Sensor Name")
            UserDefaults.standard.set(device.uid.uuidString, forKey: "Speed and Cadence Sensor UUID")
            bleManager.speedAndCadenceSensor = device
        case .power:
            UserDefaults.standard.set(device.name, forKey: "Power Meter Name")
            UserDefaults.standard.set(device.uid.uuidString, forKey: "Power Meter UUID")
            bleManager.powerMeter = device
        default: break
        }
    }
    
    func retrieveDefaultDevice() {
        switch sensorType {
        case .heartRate:
            peripheral = bleManager.heartRateSensor
            print("Retrieved Default Heart Rate Monitor Device")
        case .speedAndCadence:
            peripheral = bleManager.speedAndCadenceSensor
            print("Retrieved Default Speed and Cadence Sensor Device")
        case .power:
            peripheral = bleManager.powerMeter
            print("Retrieved Default Power Meter Device")
        default: break
        }
    }
}

struct SensorDeviceConnectionView_Previews: PreviewProvider {
    static var previews: some View {
        SensorDeviceConnectionView(bleManager: BLEManager(), sensorType: .constant(.heartRate), showSheet: .constant(true), isSensorConnected: .constant(true))
            .preferredColorScheme(.dark)
    }
}
