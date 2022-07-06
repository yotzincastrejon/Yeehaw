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
    var body: some View {
        NavigationView {
            VStack {
                List {
                    Section {
                        ZStack {
                        Rectangle()
                            .fill(Color(uiColor: .secondarySystemGroupedBackground))
                        HStack {
                            Text("Name")
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
}

struct SensorDeviceConnectionView_Previews: PreviewProvider {
    static var previews: some View {
        SensorDeviceConnectionView(bleManager: BLEManager(), sensorType: .constant(.heartRate), showSheet: .constant(true))
            .preferredColorScheme(.dark)
    }
}
