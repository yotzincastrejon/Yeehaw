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
    @State var isAnimating = false
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
                        
                        LazyVGrid(columns: columns, spacing: 10) {
                        
//                            ForEach(bleManager.saved) { item in
//                                //write a if statement to change the icon from either a heart or a speedometer based on the current item's specifications. I'm not sure how to do it quite yet but figure that out.
//                                //Also figure out how to show whether or not a peripheral is connected so you can make the foreground color blue(Connected) or gray(Not Connected)!
//
//                                BluetoothSensorView(icon: "gear", title: item.name, isConnected: bleManager.isConnected)
//                            }
                            if bleManager.saved.isEmpty {
                                
                            } else {
                                HStack(alignment: .center) {
                                    Image(systemName: "heart")
                                        .padding(.leading,10)
                                        .foregroundColor(bleManager.heartRateIsConnected ? .black : .white)
                                    VStack(alignment: .leading) {
                                        Text(bleManager.saved[0].name)
                                            .font(.subheadline)
                                            .fontWeight(.light)
                                            .foregroundColor(bleManager.heartRateIsConnected ? .black : .white)
                                        if bleManager.heartRateIsConnected {
                                            Text("Connected")
                                                .font(.subheadline)
                                                .fontWeight(.semibold)
                                                .foregroundColor(bleManager.heartRateIsConnected ? .black : .white)
                                        } else {
                                        Text("Searching...")
                                            .font(.subheadline)
                                            .fontWeight(.semibold)
                                            .opacity(isAnimating ? 0.25 : 1)
                                            .animation(Animation.linear(duration: 0.5).repeatForever(autoreverses: true))
                                        }
                                    }
                                    
                                    Spacer()
                                }
                                .frame(maxWidth: 150, maxHeight: 60)
                                .frame(minWidth: 150, minHeight: 60)
                                .background(bleManager.heartRateIsConnected ? Color("Skyblue") : Color("BackgroundElevated"))
                                .cornerRadius(10)
                                .onAppear {
                                    isAnimating = true
                                }
                                HStack(alignment: .center) {
                                    Image(systemName: "speedometer")
                                        .padding(.leading,10)
                                        .foregroundColor(bleManager.speedSensorIsConnected ? .black : .white)
                                    VStack(alignment: .leading) {
                                        Text(bleManager.saved[1].name)
                                            .font(.subheadline)
                                            .fontWeight(.light)
                                            .foregroundColor(bleManager.speedSensorIsConnected ? .black : .white)
                                        if bleManager.speedSensorIsConnected {
                                            Text("Connected")
                                                .font(.subheadline)
                                                .fontWeight(.semibold)
                                                .foregroundColor(bleManager.speedSensorIsConnected ? .black : .white)
                                        } else {
                                        Text("Searching...")
                                            .font(.subheadline)
                                            .fontWeight(.semibold)
                                            .opacity(isAnimating ? 0.25 : 1)
                                            .animation(Animation.linear(duration: 0.5).repeatForever(autoreverses: true))
                                        }
                                    }
                                    Spacer()
                                }
                                .frame(maxWidth: 150, maxHeight: 60)
                                .frame(minWidth: 150, minHeight: 60)
                                .background(bleManager.speedSensorIsConnected ? Color("Skyblue") : Color("BackgroundElevated"))
                                .cornerRadius(10)
//                                BluetoothSensorView(icon: "speedometer", title: bleManager.saved[1].name, isConnected: speedSensorIsConnected)
                            }
                            
                        }
                        .onAppear {
                            readInformation()
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                print("begin scanning")
                                bleManager.startScanning()
                            
                            }
                        }
                        .padding(.horizontal, 25)
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
    func readInformation() {
        if let data = UserDefaults.standard.data(forKey: "savedArray") {
            do {
                let arr = try JSONDecoder().decode([Saved].self, from: data)
                print(arr)
                bleManager.saved = arr
                print("we read what we were supposed to")
            } catch {
                print(error)
            }
        }
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
