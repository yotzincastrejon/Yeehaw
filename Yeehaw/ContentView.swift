//
//  ContentView.swift
//  Yeehaw
//
//  Created by Yotzin Castrejon on 3/17/21.
//

import SwiftUI


struct ContentView: View {
    @ObservedObject var bleManager: BLEManager
    
    var columns: [GridItem] = Array(repeating: .init(.flexible()), count: 2)
    @Binding var workoutInProgress: Bool
    @State var isActive: Bool = false
    var body: some View {
        ZStack {
            Color.black
            
            ActiveWorkoutView(isActive: $isActive)
       
                VStack {
                    FullScreenMap()
                        .ignoresSafeArea(.all)
                        .offset(x: 0, y: isActive ? -50 : 0)
                        .opacity(isActive ? 0 : 1)
                        .animation(.easeOut.delay(isActive ? 0 : 1), value: isActive)

                    SensorGrid(isActive: $isActive)
                    StartView(isActive: $isActive)
                        .padding([.horizontal], 20)
                        .offset(x: 0, y: isActive ? 50 : 0)
                        .opacity(isActive ? 0 : 1)
                        .animation(.easeOut.delay(isActive ? 0 : 1), value: isActive)

                }
                .background(Color(uiColor: .systemBackground))
                .opacity(isActive ? 0 : 1)
                .animation(.easeOut.delay(isActive ? 0 : 1), value: isActive)

        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView(bleManager: BLEManager(), workoutInProgress: .constant(true))
                .preferredColorScheme(.dark)
        }
    }
}


