//
//  StartWorkoutButton.swift
//  Yeehaw
//
//  Created by Yotzin Castrejon on 3/17/21.
//

import SwiftUI

struct StartWorkoutButton: View {
    @Binding var workoutStart: Bool
    @ObservedObject var stopWatchManager = StopWatchManager()
    var body: some View {
        Button(action: {
                print("Start workout tapped")
            workoutStart = true
//            stopWatchManager.start()
        }) {
            Text("Start Workout".uppercased())
                .font(Font.custom("RBNo2.1a-Bold", size: 25))
                .foregroundColor(Color.black)
                .frame(minWidth: 0, maxWidth: .infinity)
                .padding(10)
                .background(Color("Skyblue"))
        }
        .padding(.horizontal)
    }
}

struct StartWorkoutButton_Previews: PreviewProvider {
    static var previews: some View {
        StartWorkoutButton(workoutStart: .constant(true))
    }
}
