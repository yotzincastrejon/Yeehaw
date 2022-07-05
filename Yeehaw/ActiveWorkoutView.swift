//
//  ActiveWorkoutView.swift
//  Yeehaw
//
//  Created by Yotzin Castrejon on 6/28/22.
//

import SwiftUI
import HealthKit

struct ActiveWorkoutView: View {
    @Binding var isActive: Bool

    var body: some View {
        
            VStack {
                TimeBlock()
                SpeedAndCadenceBlock()
                HeartRateBlock()
                DistanceBlock()
                PowerBlock()
                PauseButton(isActive: $isActive)
                    .frame(width: UIScreen.main.bounds.width * 100/428, height:UIScreen.main.bounds.height * 100/926)
            }
            .padding(.horizontal)
    }
}

struct ActiveWorkoutView_Previews: PreviewProvider {
    @Namespace static var namespace

    static var previews: some View {
        Group {
            ActiveWorkoutView(isActive: .constant(true))
                .preferredColorScheme(.dark)
            ActiveWorkoutView(isActive: .constant(true))
                .previewDevice("iPhone 8")
                .preferredColorScheme(.dark)
        }
    }
}

struct SpeedAndCadenceBlock: View {
    var body: some View {
        ZStack {
            WorkoutStatsBlockBackground(baseColor: .green)
            HStack(spacing: 0) {
                
                StatisticsView(image: Image(systemName: "speedometer"), imageColor: .green, stat: "16", unit: "mph")
                   
                
                StatisticsView(image: Image("Crank"), imageColor: .green, stat: "72", unit: "rpm")
                
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
    var body: some View {
        GeometryReader { g in
            ZStack {
                WorkoutStatsBlockBackground(baseColor: .red)
                HStack {
                    StatisticsView(image: Image(systemName: "heart.fill"), imageColor: .red, stat: "120", unit: "bpm")
                    
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
    var body: some View {
        GeometryReader { g in
            ZStack {
                WorkoutStatsBlockBackground(baseColor: .blue)
                HStack {
                    StatisticsView(image: Image(systemName: "location.fill"), imageColor: .blue, stat: "12.9", unit: "miles")
                    VStack {
                        VStack(alignment: .leading) {
                            HStack {
                                Image("Elevation")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: g.size.height * 25/150)
                                    .shadow(color: .black.opacity(0.25), radius: 4, x: 0, y: 4)
                                HStack(alignment: .firstTextBaseline, spacing: 2) {
                                Text("1096")
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
                                Text("1")
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
    var body: some View {
        ZStack {
            WorkoutStatsBlockBackground(baseColor: .yellow)
            HStack {
                StatisticsView(image: Image(systemName: "bolt.fill"), imageColor: .yellow, stat: "150", unit: "watts")
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
    @State var stat: String
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
                    .font(.system(size: g.size.height * 64/150, weight: .bold))
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
    @Binding var isActive: Bool
    var body: some View {
        Button(action: {
            // Do something
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
