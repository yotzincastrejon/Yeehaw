//
//  DefaultSensors.swift
//  Yeehaw
//
//  Created by Yotzin Castrejon on 4/7/22.
//

import SwiftUI

struct DefaultSensors: View {
    @ObservedObject var bleManager: BLEManager
    var columns: [GridItem] = Array(repeating: .init(.flexible()), count: 2)
    @State var isAnimating = false
    var body: some View {
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
//                        Text(bleManager.saved[1].name)
//                            .font(.subheadline)
//                            .fontWeight(.light)
//                            .foregroundColor(bleManager.speedSensorIsConnected ? .black : .white)
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
            
//            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
//                print("begin scanning")
//                bleManager.startScanning()
//                
//            }
        }
        .padding(.horizontal, 25)
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

struct DefaultSensors_Previews: PreviewProvider {
    static var previews: some View {
        DefaultSensors(bleManager: BLEManager())
    }
}
