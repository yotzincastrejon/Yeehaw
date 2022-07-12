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
    @StateObject var mapViewModel = MapViewModel()
//    @StateObject var locationManager = CLLocationManager()
    var body: some View {
            ContentView(bleManager: bleManager, mapViewModel: mapViewModel, workoutInProgress: $workoutInProgress)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .preferredColorScheme(.dark)
        
    }
}
