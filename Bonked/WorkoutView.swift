//
//  WorkoutView.swift
//  Yeehaw
//
//  Created by Yotzin Castrejon on 3/18/21.
//

import SwiftUI
import CoreGraphics

struct WorkoutView: View {
    @ObservedObject var bleManager: BLEManager
    @Binding var workoutProgress: Bool
    @StateObject var workoutSession = HealthKitManager()
    @StateObject var stopWatchManager = StopWatchManager()
    @StateObject var locationHelper = LocationHelper()
    @State var timer = "--"
    @State var backgroundColor = Color.clear
    @State var distanceTraveled = 0.0
    @State var stopwatchManagerMode = ".stopped"
    @State var wheelIsGivingData = false

    var body: some View {
        VStack(spacing: 0) {
            //Speed...
            Group {
                
                VStack {
                    HStack {
                        Text("Speed")
                            .font(.title)
                        if bleManager.wheelupdated < 8 {
                        LittleBox(wheelupdated: bleManager)
                        }
                    }
                    HStack {
                        Text("\(bleManager.speedLabel)")
                            .font(.system(size: 70, design: .monospaced))
                            .fontWeight(.bold)
                            .minimumScaleFactor(0.8)
                            
                        VStack() {
                            Text("mph")
                                .font(.title)
                                .fontWeight(.bold)

                        }
                    }
                }
                .frame(minWidth: 0, maxWidth: .infinity)
                HorizontalDivider()
            }
            
            //Cadence and Heart Rate
            Group {
                HStack {
                    VStack {
                        HStack {
                            Text("Cadence")
                                .font(.title)
                            if bleManager.wheelupdated < 8 {
                            LittleBox(wheelupdated: bleManager)
                            }
                        }
                        Text("\(bleManager.cadenceLabel)")
                            .font(.system(size: 50, design: .monospaced))
                            .fontWeight(.bold)
                            .minimumScaleFactor(0.8)
                    }
                    .frame(maxWidth: UIScreen.main.bounds.width / 2)
                    VerticalDivider()
                    
                    
                    VStack {
                        Text("Heart Rate")
                            .font(.title)
                        Text("\(bleManager.heartRateLabel)")
                            .font(.system(size: 50, design: .monospaced))
                            .fontWeight(.bold)
                            .minimumScaleFactor(0.8)
                    }
                    .frame(maxWidth: UIScreen.main.bounds.width / 2)
                    .background(colorPicker(heartrate: bleManager.heartRateNumber))
                    
                    
                    
                    
                }
            }
            
            //Distance...
            Group {
                HorizontalDivider()
                VStack {
                    HStack {
                        Text("Distance")
                            .font(.title)
                        if bleManager.wheelupdated < 8 {
                        LittleBox(wheelupdated: bleManager)
                        }
                    }
                    ZStack {
                    HStack {
                        Text("\(String(format: "%.2f" ,(distanceTraveled * (1/1609.344))))")
                            
                            .font(.system(size: 70, design: .monospaced))
                            .fontWeight(.bold)
                            .minimumScaleFactor(0.8)
                        VStack(spacing: -10) {
                            Text("m")
                                .font(.title)
                                .fontWeight(.bold)
                            Text("i")
                                .font(.title)
                                .fontWeight(.bold)
                        }
                        if bleManager.wheelupdated < 8 {
                            VStack {
                                Text("Raw Data")
                                Text("\(bleManager.distanceRateinMeters)")
                                Text("Stopwatch Mode:")
                                Text("\(stopwatchManagerMode)")
                                
                            }
                        }
                        }
                    }
                }
                .frame(minWidth: 0, maxWidth: .infinity)
            }
            
            
            //Timer...
            Group {
                HorizontalDivider()
                VStack {
                    Text("Timer")
                        .font(.title)
                    Text("\(stopWatchManager.timeShown)")
                        .font(.system(size: 70, design: .monospaced))
                        .fontWeight(.bold)
                        .minimumScaleFactor(0.8)
                    
                }
                .frame(minWidth: 0, maxWidth: .infinity)
                HorizontalDivider()
            }
            
            
            //Calories and Total Ascent...
//            Group {
//                HStack {
//                    VStack {
//                        Text("Calories")
//                            .font(.title)
//                        Text("--")
//                            .font(.system(size: 50))
//                            .fontWeight(.bold)
//                            .minimumScaleFactor(0.8)
//                    }
//                    .frame(maxWidth: UIScreen.main.bounds.width / 2)
//                    VerticalDivider()
//                    
//                    VStack {
//                        Text("Totl.Ascent")
//                            .font(.title)
//                        Text("--")
//                            .font(.system(size: 50))
//                            .fontWeight(.bold)
//                            .minimumScaleFactor(0.8)
//                    }
//                    .frame(maxWidth: UIScreen.main.bounds.width / 2)
//                }
//                HorizontalDivider()
//            }
            
            //Clock...
            Group {
                
                VStack {
                    Text("Clock")
                        .font(.title)
                    Text(timer)
                        .font(.system(size: 50, design: .monospaced))
                        .fontWeight(.bold)
                        .minimumScaleFactor(0.8)
                }
                .frame(minWidth: 0, maxWidth: .infinity)
                .frame(height: UIScreen.main.bounds.height / 8)
                
            }
            
            if bleManager.wheelupdated >= 0 {
                Group {
                if stopWatchManager.mode == .stopped {
                    Button(action: {
                        print("Start button was tapped")
                        stopwatchManagerMode = ".running"
                        stopWatchManager.start()
                        print(stopWatchManager.mode)
                        workoutSession.startSession(date: Date())
                        locationHelper.beginTrackingLocation { location in
                            if location.horizontalAccuracy < 30 && location.verticalAccuracy < 30 {
                                workoutSession.appendWorkoutData(location)
                                print("location altitude: \(location.altitude)")
                            }
                        }
                    }) {
                        Text("Start")
                            .font(.title)
                            .fontWeight(.medium)
                            .frame(maxWidth: .infinity, maxHeight: 50)
                    }
                    .background(Color.blue)
                    .foregroundColor(.white)
                }
                if stopWatchManager.mode == .running {
                    Button(action: {
                        print("pause button was tapped")
                        stopWatchManager.pause()
                        stopwatchManagerMode = ".paused"
                    }) {
                        Text("Pause")
                            .font(.title)
                            .fontWeight(.medium)
                            .frame(maxWidth: .infinity, maxHeight: 50)
                    }
                    .background(Color.orange)
                    .foregroundColor(.white)
                }
                if stopWatchManager.mode == .paused {
                    HStack {
                        Button(action: {
                            print("Resume button was tapped")
                            stopWatchManager.start()
                            stopwatchManagerMode = ".running"
                        }) {
                            Text("Resume")
                                .font(.title)
                                .fontWeight(.medium)
                                .frame(maxWidth: .infinity, maxHeight: 50)
                        }
                        .background(Color.green)
                        .foregroundColor(.white)
                        Button(action: {
                            print("Stop button was tapped")
                            stopwatchManagerMode = ".stopped"
                            distanceTraveled = 0.0
                            workoutProgress = false
                            stopWatchManager.stop()
                            workoutSession.finishSession()
                            locationHelper.stopTrackingLocation()
                        }) {
                            Text("Stop")
                                .font(.title)
                                .fontWeight(.medium)
                                .frame(maxWidth: .infinity, maxHeight: 50)
                        }
                        .background(Color.red)
                        .foregroundColor(.white)
                    }
                }
                
                }
            } 
            
        }
        .onAppear {
            //stops the screen from going to sleep.
            UIApplication.shared.isIdleTimerDisabled = true
            workoutSession.requestAuthorization()
            locationHelper.requestAuthorization()
            let _ = self.updateTimer
        }
    }
    func format(date: Date) -> String {
        let df = DateFormatter()
        df.dateFormat = "h:mm a"
        return df.string(from: date)
    }
    
    // Convert the seconds into seconds, minutes, hours.
    func secondsToHoursMinutesSeconds (seconds: Int) -> (Int, Int, Int) {
      return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
    // Convert the seconds, minutes, hours into a string.
    func elapsedTimeString(elapsed: (h: Int, m: Int, s: Int)) -> String {
        return String(format: "%d:%02d:%02d", elapsed.h, elapsed.m, elapsed.s)
    }
    
    func updatingDistance(distance: Double) {
        var finaldistance = distance
        if finaldistance.isNaN {
        finaldistance = 0
        }
        distanceTraveled = distanceTraveled + finaldistance
    }
    
    
    
    
    var updateTimer: Timer {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: {_ in
            self.timer = format(date: Date())
            if stopWatchManager.mode == .running {
                updatingDistance(distance: bleManager.distanceRateinMeters)
                workoutSession.addDistanceSample(bleManager.distanceRateinMeters)
                workoutSession.addHeartRateSample(Double(bleManager.heartRateNumber))
            }
        })
    }
    
    func colorPicker(heartrate: Int) -> Color {
        if heartrate <= 116 {
            return Color(#colorLiteral(red: 0.1843137255, green: 0.5764705882, blue: 0.8980392157, alpha: 1))
        } else {
        if heartrate >= 117 && heartrate <= 136 {
            return Color(#colorLiteral(red: 0.1843137255, green: 0.8, blue: 0.6823529412, alpha: 1))
        } else {
            if heartrate >= 137 && heartrate <= 155 {
                return Color(#colorLiteral(red: 0.9294117647, green: 0.8274509804, blue: 0.1960784314, alpha: 1))
            } else {
                if heartrate >= 156 && heartrate <= 175 {
                    return Color(#colorLiteral(red: 0.937254902, green: 0.4745098039, blue: 0.1960784314, alpha: 1))
                } else {
                    if heartrate >= 176 {
                        return Color(#colorLiteral(red: 0.8431372549, green: 0.1803921569, blue: 0.3647058824, alpha: 1))
                    }
                }
            }
        }
        }
        
        
        return Color.clear
    }
    
    
}


struct WorkoutView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            WorkoutView(bleManager: BLEManager(), workoutProgress: .constant(true))
                
            WorkoutView(bleManager: BLEManager(), workoutProgress: .constant(true))
                .previewDevice("iPhone 8")
                
        }
    }
}

struct HorizontalDivider: View {
    let color: Color = .blue
    let width: CGFloat = 1
    var body: some View {
        Rectangle()
            .fill(color)
            .frame(height: width)
            .edgesIgnoringSafeArea(.horizontal)
    }
}

struct VerticalDivider: View {
    let color: Color = .blue
    let width: CGFloat = 1
    var body: some View {
        Rectangle()
            .fill(color)
            .frame(width: width, height: UIScreen.main.bounds.height / 8)
        
    }
}
