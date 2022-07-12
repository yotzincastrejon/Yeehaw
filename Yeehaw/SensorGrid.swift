//
//  SensorGrid.swift
//  Yeehaw
//
//  Created by Yotzin Castrejon on 6/27/22.
//

import SwiftUI

struct SensorGrid: View {
    @ObservedObject var bleManager: BLEManager
    @Binding var isActive: Bool
    let columns = [GridItem(.flexible(), spacing: 20),GridItem(.flexible(), spacing: 20)]
    @State var showSheet = false
    @State var sensorType: SensorType? = nil
    @State var powerIsConnected = false
    @State var speedIsConnected = false
    @State var heartRateIsConnected = false
    @State var locationIsConnected = false
    var body: some View {
            LazyVGrid(columns: columns, spacing: 20) {
                SensorView(isActive: $isActive, isConnected: $bleManager.heartRateSensorState, sensorSystemImageName: "heart.fill", baseColor: .red)
                    .opacity(isActive ? 0 : 1)
                    .offset(x: 0, y: isActive ? -50 : 0)
                    .animation(.easeOut.delay(isActive ? 0 : 1), value: isActive)
                    .onTapGesture {
                        sensorType = .heartRate
                        heartRateIsConnected.toggle()
                        showSheet = true
                    }
                SensorViewSpeedandCadence(isActive: $isActive, isConnected: $speedIsConnected)
                    .opacity(isActive ? 0 : 1)
                    .offset(x: 0, y: isActive ? -50 : 0)
                    .animation(.easeOut.delay(isActive ? 0 : 1), value: isActive)
                    .onTapGesture {
                        sensorType = .speedAndCadence
                        speedIsConnected.toggle()
                        showSheet = true
                    }
                    
                    
                SensorView(isActive: $isActive, isConnected: $powerIsConnected,sensorSystemImageName: "bolt.fill", baseColor: .yellow)
                    .opacity(isActive ? 0 : 1)
                    .offset(x:isActive ? -50 : 0, y: 0)
                    .animation(.easeOut.delay(isActive ? 0 : 1), value: isActive)
                    .onTapGesture {
                        sensorType = .power
                        powerIsConnected.toggle()
                        showSheet = true
                    }
                SensorView(isActive: $isActive, isConnected: $locationIsConnected, sensorSystemImageName: "location.fill", baseColor: .blue)
                    .opacity(isActive ? 0 : 1)
                    .offset(x: isActive ? 50 : 0, y: 0)
                    .animation(.easeOut.delay(isActive ? 0 : 1), value: isActive)
                    .onTapGesture {
                        locationIsConnected.toggle()
                    }
            }
            .padding(20)
            .sheet(isPresented: $showSheet) {
                SensorDeviceConnectionView(bleManager: bleManager, sensorType: $sensorType, showSheet: $showSheet, isSensorConnected: isSheetSensorConnected(sensorType: sensorType ?? .heartRate))
            }
    }
    
    func isSheetSensorConnected(sensorType: SensorType) -> Binding<Bool> {
        //Make a switch statement based on sensorType we should pass a sensor state for a given sensor.
        switch sensorType {
        case .heartRate:
           return $bleManager.heartRateSensorState
        case .speedAndCadence:
            return $bleManager.speedAndCadenceSensorState
        case .power:
            return $bleManager.powerMeterState
        }
    }
}

struct SensorGrid_Previews: PreviewProvider {
    @Namespace static var namespace
    static var previews: some View {
        SensorGrid(bleManager: BLEManager(), isActive: .constant(false))
            .preferredColorScheme(.dark)
    }
}

enum SensorType: CustomStringConvertible, CaseIterable {
    case heartRate
    case speedAndCadence
    case power
    
    var description: String {
        switch self {
            case .heartRate: return "Heart Rate"
            case .speedAndCadence: return "Speed and Cadence"
            case .power: return "Power"
        }
    }
}
