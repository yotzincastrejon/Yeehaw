//
//  ActiveWorkoutView.swift
//  Yeehaw
//
//  Created by Yotzin Castrejon on 6/28/22.
//

import SwiftUI
import HealthKit

struct ActiveWorkoutView: View {
    @ObservedObject var bleManager: BLEManager
    @ObservedObject var locationHelper: LocationHelper
    @Binding var isActive: Bool
    @State var isLowPowerMode: Bool = false
    var body: some View {
        
            VStack {
                TimeBlock()
                    .opacity(isActive ? 1 : 0)
                    .offset(x:isActive ? 0 : 200, y: 0)
                    .animation(.easeOut.delay(isActive ? 0.5 : 0.4), value: isActive)
                SpeedAndCadenceBlock(bleManager: bleManager, locationHelper: locationHelper, isLowPowerMode: $isLowPowerMode)
                    .opacity(isActive ? 1 : 0)
                    .offset(x:isActive ? 0 : 200, y: 0)
                    .animation(.easeOut.delay(isActive ? 0.6 : 0.3), value: isActive)
                HeartRateBlock(bleManager: bleManager,isLowPowerMode: $isLowPowerMode)
                    .opacity(isActive ? 1 : 0)
                    .offset(x:isActive ? 0 : 200, y: 0)
                    .animation(.easeOut.delay(isActive ? 0.7 : 0.2), value: isActive)
                DistanceBlock(bleManager: bleManager, locationHelper: locationHelper, isLowPowerMode: $isLowPowerMode)
                    .opacity(isActive ? 1 : 0)
                    .offset(x:isActive ? 0 : 200, y: 0)
                    .animation(.easeOut.delay(isActive ? 0.8 : 0.1), value: isActive)
                PowerBlock(isLowPowerMode: $isLowPowerMode)
                    .opacity(isActive ? 1 : 0)
                    .offset(x:isActive ? 0 : 200, y: 0)
                    .animation(.easeOut.delay(isActive ? 0.9 : 0), value: isActive)
                PauseButton(locationHelper: locationHelper, isActive: $isActive)
                    .frame(width: UIScreen.main.bounds.width * 100/428, height:UIScreen.main.bounds.height * 100/926)
            }
            .padding(.horizontal)
    }
}

struct ActiveWorkoutView_Previews: PreviewProvider {
    @Namespace static var namespace

    static var previews: some View {
        Group {
            ActiveWorkoutView(bleManager: BLEManager(), locationHelper: LocationHelper(), isActive: .constant(true), isLowPowerMode: true)
                .preferredColorScheme(.dark)
            ActiveWorkoutView(bleManager: BLEManager(), locationHelper: LocationHelper(), isActive: .constant(true))
                .previewDevice("iPhone 8")
                .preferredColorScheme(.dark)
        }
    }
}

struct SpeedAndCadenceBlock: View {
    @ObservedObject var bleManager: BLEManager
    @ObservedObject var locationHelper: LocationHelper
    @Binding var isLowPowerMode: Bool
    var body: some View {
        ZStack {
            if isLowPowerMode {
                RoundedRectangle(cornerRadius: 20, style: .circular)
                    .stroke(Color.green)
            } else {
            WorkoutStatsBlockBackground(baseColor: .green)
                RoundedRectangle(cornerRadius: 20, style: .circular)
                    .stroke(Color.green)
            }
            HStack(spacing: 0) {
                if bleManager.speedSensorIsConnected {
                StatisticsView(image: Image(systemName: "speedometer"), imageColor: .green, stat: $bleManager.speedLabel, unit: "mph")
                } else {
                    StatisticsView(image: Image(systemName: "speedometer"), imageColor: .green, stat: $locationHelper.speed, unit: "mph")
                }
                
                StatisticsView(image: Image("Crank"), imageColor: .green, stat: $bleManager.cadenceLabel, unit: "rpm")
                
            }

            
        }
    }
}

struct TimeBlock: View {
    var body: some View {
        GeometryReader { g in
            ZStack {
                RoundedRectangle(cornerRadius: 20, style: .circular)
                    .stroke()
                    
                Text("01:07:38")
                    .font(.system(size: g.size.height * 64/150, weight: .bold))
                    .foregroundColor(.white)
            }
        }
    }
}

struct HeartRateBlock: View {
    @ObservedObject var bleManager: BLEManager
    @Binding var isLowPowerMode: Bool
    var body: some View {
        GeometryReader { g in
            ZStack {
                if isLowPowerMode {
                    RoundedRectangle(cornerRadius: 20, style: .circular)
                        .stroke(Color.red)
                } else {
                WorkoutStatsBlockBackground(baseColor: .red)
                    RoundedRectangle(cornerRadius: 20, style: .circular)
                        .stroke(Color.red)
                }
                HStack {
                    StatisticsView(image: Image(systemName: "heart.fill"), imageColor: .red, stat: $bleManager.heartRateLabel, unit: "bpm")
                    
                    VStack {
                        Text("Zone")
                            .font(.system(size: g.size.height * 20/150, weight: .bold))
                            .foregroundColor(.white.opacity(0.8))
                            
                       
                        Text("1.5")
                            .font(.system(size: g.size.height * 64/150, weight: .bold))
                            .foregroundColor(.white)
                        Text("recovery")
                            .font(.callout)
                            .fontWeight(.bold)
                            .foregroundColor(.white.opacity(0.8))
                    }
                    .frame(maxWidth: .infinity)
                    
                }
            }
            .frame(width: g.size.width, height: g.size.height)
        }
    }
}

struct DistanceBlock: View {
    @ObservedObject var bleManager: BLEManager
    @ObservedObject var locationHelper: LocationHelper
    @Binding var isLowPowerMode: Bool
    var body: some View {
        GeometryReader { g in
            ZStack {
                if isLowPowerMode {
                    RoundedRectangle(cornerRadius: 20, style: .circular)
                        .stroke(Color.blue)
                } else {
                WorkoutStatsBlockBackground(baseColor: .blue)
                    RoundedRectangle(cornerRadius: 20, style: .circular)
                        .stroke(Color.blue)
                }
                HStack {
                    if bleManager.speedSensorIsConnected {
                    StatisticsView(image: Image(systemName: "location.fill"), imageColor: .blue, stat: $bleManager.distanceTraveledString, unit: "miles")
                    } else {
                        StatisticsView(image: Image(systemName: "location.fill"), imageColor: .blue, stat: $locationHelper.traveledDistanceString, unit: "miles")
                    }
                    VStack {
                        VStack(alignment: .leading) {
                            HStack {
                                Image("Elevation")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: g.size.height * 25/150)
                                    .shadow(color: .black.opacity(0.25), radius: 4, x: 0, y: 4)
                                HStack(alignment: .firstTextBaseline, spacing: 2) {
                                    Text(locationHelper.elevationGainString)
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                Text("ft")
                                    .font(.callout)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white.opacity(0.8))
                                }
                            }
                            
                            HStack {
                                Image("Grade")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: g.size.height * 25/150)
                                    .shadow(color: .black.opacity(0.25), radius: 4, x: 0, y: 4)
                                HStack(alignment: .firstTextBaseline, spacing: 2) {
                                    Text(locationHelper.elevationSlope)
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                Text("%")
                                    .font(.callout)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white.opacity(0.8))
                                }
                            }
                        }
                        
                    }.frame(maxWidth: .infinity)
                }
            }
            .frame(width: g.size.width, height: g.size.height)
        }
    }
}

struct PowerBlock: View {
    @Binding var isLowPowerMode: Bool
    var body: some View {
        ZStack {
            if isLowPowerMode {
                RoundedRectangle(cornerRadius: 20, style: .circular)
                    .stroke(Color.yellow)
            } else {
            WorkoutStatsBlockBackground(baseColor: .yellow)
                RoundedRectangle(cornerRadius: 20, style: .circular)
                    .stroke(Color.yellow)
            }
            HStack {
                StatisticsView(image: Image(systemName: "bolt.fill"), imageColor: .yellow, stat: Binding.constant("150"), unit: "watts")
            }
        }
//        .frame(height: UIScreen.main.bounds.height * 150/926)
    }
}

struct WorkoutStatsBlockBackground: View {
    let baseColor: Color
    var body: some View {
        GeometryReader { g in
            ZStack {
                ZStack {
                    Rectangle()
                        .fill(LinearGradient(colors: [baseColor,baseColor,Color(hex: "D9D9D9").opacity(0)], startPoint: .bottom, endPoint: .top))
                    .frame(width: g.size.width)
                }
                .blur(radius: 60)
                
                Rectangle()
                    .fill(Color(hex: "1C1C1E").opacity(0.2))
            }
            .frame(width: g.size.width, height: g.size.height)
        }
        .frame(maxWidth: .infinity)
        .cornerRadius(20)
    }
}

struct StatisticsView: View {
    let image: Image
    let imageColor: Color
    @Binding var stat: String
    let unit: String
    var body: some View {
        GeometryReader { g in
            VStack(spacing: 0) {
                image
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(imageColor)
                    .frame(height: g.size.height * 25/150)
                    .shadow(color: .black.opacity(0.25), radius: 4, x: 0, y: 4)
                    
                Text(stat)
                    .font(.system(size: g.size.height * 64/150, weight: .bold).monospacedDigit())
                    .foregroundColor(.white)
                    
                    
                Text(unit)
                    .font(.callout)
                    .fontWeight(.bold)
                    .foregroundColor(.white.opacity(0.8))
                
            }
            .frame(width: g.size.width, height: g.size.height)
            .frame(maxWidth: .infinity)
        }
    }
}

struct PauseButton: View {
    @ObservedObject var locationHelper: LocationHelper
    @Binding var isActive: Bool
    var body: some View {
        Button(action: {
            // Do something
            locationHelper.stopTracking()
            withAnimation(.spring()) {
            isActive.toggle()
            }
        }) {
            GeometryReader { g in
                ZStack {
                    Circle()
                        .fill(LinearGradient(colors: [Color(hex: "FF5400"), Color(hex: "FF6D00")], startPoint: .bottom, endPoint: .top))
                        
                    Image(systemName: "pause")
                        .font(.system(size: g.size.height * 50/100, weight: .bold))
                        .frame(height: 40)
                        .foregroundColor(.white)
                }
            }
        }
    }
}
