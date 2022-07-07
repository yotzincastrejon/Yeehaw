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
    var body: some View {
        NavigationView {
            VStack {
                List {
                    Section {
                        ZStack {
                        Rectangle()
                            .fill(Color(uiColor: .secondarySystemGroupedBackground))
                        HStack {
                            Text(peripheral?.name ?? "No Default Device")
                            Spacer()
                            Text("Not Connected")
                                .foregroundColor(.secondary)
                        }
                    }
                    .cornerRadius(20)
                .padding(.horizontal)
                    }
                header: {
                   Text("My Devices")
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
            UserDefaults.standard.set(Peripheral(name: device.name, rssi: device.rssi, uid: device.uid), forKey: "Speed and Cadence Sensor")
        case .power:
            UserDefaults.standard.set(Peripheral(name: device.name, rssi: device.rssi, uid: device.uid), forKey: "Power Meter")
        default: break
        }
    }
    
    func retrieveDefaultDevice() {
        switch sensorType {
        case .heartRate:
            peripheral = bleManager.heartRateSensor
            print("Retrieved Default Device")
        case .speedAndCadence:
            peripheral = bleManager.speedAndCadenceSensor
        case .power:
            peripheral = bleManager.powerMeter
        default: break
        }
    }
}

struct SensorDeviceConnectionView_Previews: PreviewProvider {
    static var previews: some View {
        SensorDeviceConnectionView(bleManager: BLEManager(), sensorType: .constant(.heartRate), showSheet: .constant(true))
            .preferredColorScheme(.dark)
    }
}
