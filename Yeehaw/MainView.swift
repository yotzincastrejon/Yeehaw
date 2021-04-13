//
//  MainView.swift
//  Yeehaw
//
//  Created by Yotzin Castrejon on 4/9/21.
//

import SwiftUI

struct MainView: View {
    @State var workoutInProgress = false
    @StateObject var bleManager = BLEManager()
    var body: some View {
        GeometryReader { geometry in
            TabView {
                ContentView(bleManager: bleManager, workoutInProgress: $workoutInProgress)
                    .tabItem { Label("Workout", systemImage: "bicycle") }
                History()
                    .tabItem { Label("History", systemImage: "clock.arrow.circlepath") }
                Profile()
                    .tabItem { Label("Profile", systemImage: "person.crop.circle.fill") }
                Settings()
                    .tabItem { Label("Settings", systemImage: "gearshape.fill") }
            }
            .accentColor(Color("Skyblue"))
            .preferredColorScheme(.dark)
            .opacity(workoutInProgress ? 0 : 1)
            .overlay(
                WorkoutView(bleManager: bleManager, workoutProgress: $workoutInProgress)
                    .offset(CGSize(width: 0, height: workoutInProgress ? 0 : geometry.size.height + 100))
                    .animation(.easeInOut(duration: 0.1))
                    .ignoresSafeArea(.all)
            )
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            
        
    }
}
