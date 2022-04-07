//
//  ContentView.swift
//  Yeehaw
//
//  Created by Yotzin Castrejon on 3/17/21.
//

import SwiftUI
import MapKit


struct ContentView: View {
    @ObservedObject var bleManager: BLEManager
    @State var isActive: Bool = false
    var columns: [GridItem] = Array(repeating: .init(.flexible()), count: 2)
    @Binding var workoutInProgress: Bool
    var body: some View {
        GeometryReader { geometry in
            NavigationView {
                VStack {
    
                    Home()
                        .ignoresSafeArea(.all)
                    ScrollView {
                        HStack {
                            Image(systemName: "bicycle")
                                .font(.title2)
                            Text("Cycling".uppercased())
                                .font(Font.custom("RBNo2.1a-Bold", size: 25))
                            Spacer()
                        }
                        .padding(.vertical, 10)
                        .padding(.leading)
                        Divider()
                        StartWorkoutButton(workoutStart: $workoutInProgress)
                            .padding(.vertical,5)
                        Divider()
                        HStack {
                            Text("Linked Sensors".uppercased())
                                .font(.footnote)
                                .fontWeight(.semibold)
                            Spacer()
                            NavigationLink(
                                destination: LinkedSensorsView(bleManager: bleManager, rootIsActive: $isActive), isActive: self.$isActive
                                
                            ) {
                                Text("Edit")
                                    .accentColor(Color("Skyblue"))
                            }
                            .isDetailLink(false)
                        }
                        .padding()
                        
                        DefaultSensors(bleManager: bleManager)
    //                    .padding(.bottom)
                    }
                }
                .background(Color("Background"))
                .ignoresSafeArea(.all)
            }
            .navigationViewStyle(StackNavigationViewStyle())
            
        }
        //end of navigation view
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            //            ContentView()
            //                .preferredColorScheme(.light)
            ContentView(bleManager: BLEManager(), workoutInProgress: .constant(true))
                .preferredColorScheme(.dark)
        }
        
        
        
        
    }
}


