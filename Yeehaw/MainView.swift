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
            ContentView(bleManager: bleManager, workoutInProgress: $workoutInProgress)
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .preferredColorScheme(.dark)
        
    }
}
