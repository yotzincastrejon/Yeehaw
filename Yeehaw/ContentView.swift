//
//  ContentView.swift
//  Yeehaw
//
//  Created by Yotzin Castrejon on 3/17/21.
//

import SwiftUI


struct ContentView: View {
    @ObservedObject var bleManager: BLEManager
    @ObservedObject var mapViewModel: MapViewModel
    @ObservedObject var locationHelper: LocationHelper
    var columns: [GridItem] = Array(repeating: .init(.flexible()), count: 2)
    @Binding var workoutInProgress: Bool
    @State var isActive: Bool = false
    var body: some View {
        ZStack {
            Color.black
            
            ActiveWorkoutView(bleManager: bleManager, locationHelper: locationHelper, isActive: $isActive)
       
                VStack {
                    FullScreenMap(mapData: mapViewModel)
                        .ignoresSafeArea(.all)
                        .offset(x: 0, y: isActive ? -50 : 0)
                        .opacity(isActive ? 0 : 1)
                        .animation(.easeOut.delay(isActive ? 0 : 1), value: isActive)

                    SensorGrid(bleManager: bleManager, locationHelper: locationHelper, isActive: $isActive)
                    StartView(isActive: $isActive)
                        .padding([.horizontal], 20)
                        .offset(x: 0, y: isActive ? 50 : 0)
                        .opacity(isActive ? 0 : 1)
                        .animation(.easeOut.delay(isActive ? 0 : 1), value: isActive)

                }
                .background(Color(uiColor: .systemBackground))
                .opacity(isActive ? 0 : 1)
                .animation(.easeOut.delay(isActive ? 0 : 1), value: isActive)
                .onChange(of: bleManager.readyToBeScanned) { boolValue in
                    if boolValue {
                    bleManager.startScanning()
                    }
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView(bleManager: BLEManager(), mapViewModel: MapViewModel(), locationHelper: LocationHelper(), workoutInProgress: .constant(true))
                .preferredColorScheme(.dark)
        }
    }
}


