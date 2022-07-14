//
//  SensorView.swift
//  Yeehaw
//
//  Created by Yotzin Castrejon on 6/27/22.
//

import SwiftUI

struct SensorView: View {
    @Binding var isActive: Bool
    @Binding var isConnected: Bool
    @State var isDelayed: Bool = false
    @Binding var mainStat: Int
    let statDescription: String
    let sensorSystemImageName: String
    let baseColor: Color
    var body: some View {
        
        GeometryReader { g in
            ZStack {
                Rectangle()
                    .fill(isDelayed ? LinearGradient(colors: [baseColor,baseColor,Color(hex: "D9D9D9").opacity(0)], startPoint: .bottom, endPoint: .top) : LinearGradient(colors: [Color(uiColor: .secondarySystemGroupedBackground)], startPoint: .center, endPoint: .center))
                    .frame(width: g.size.width, height: g.size.height)
                    .blur(radius: isDelayed ? 45 : 0)
                    .animation(.easeOut, value: isDelayed)
                    .onChange(of: isConnected) { newValue in
                        if !newValue {
                            isDelayed.toggle()
                        } else {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                isDelayed.toggle()
                            }
                        }
                        
                    }
                
                RoundedRectangle(cornerRadius: 20)
                    .stroke(lineWidth: 2)
                    .foregroundColor(.red)
                    .opacity(isConnected ? 1 : 0)
                    .animation(.linear(duration: 0.25).repeatCount(isConnected ? 5 : 0, autoreverses: true), value: isConnected)
                
                Rectangle()
                    .fill(Color(hex: "1C1C1E").opacity(isConnected ? 0.2 : 0))
                
                VStack {
                    Image(systemName: sensorSystemImageName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: g.size.width * 50/180, height: g.size.height * 50/100)
                        .foregroundColor(isConnected ? baseColor : .white)
                        .shadow(color: .black.opacity(isConnected ? 0.25 : 0), radius: 4, x: 0, y: 4)
                        .animation(.easeOut.delay(isConnected ? 1.5 : 0), value: isConnected)
                        .scaleEffect(isConnected ? 0.5 : 1)
                        .animation(.easeOut.delay(isConnected ? 1.5 : 0), value: isConnected)
                    if isConnected {
                        Spacer()
                    }
                }
                
                VStack(spacing: 0) {
                    Spacer()
                    Text("\(mainStat)")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    Text(statDescription)
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.white.opacity(0.8))
                        .padding(.bottom,5)
                }
                .opacity(isConnected ? 1 : 0)
                .animation(.easeOut.delay(isConnected ? 2.25 : 0), value: isConnected)
            }
            .frame(width: g.size.width, height: g.size.height)
            
        }
        .frame(width: UIScreen.main.bounds.width * 180/428, height: UIScreen.main.bounds.height * 100/926)
        .cornerRadius(20)
        
        
        
        
    }
}

struct SensorView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            //            SensorView(isActive: .constant(false), isConnected: .constant(true), sensorSystemImageName: "heart.fill", baseColor: .red)
            SensorViewSpeedandCadence(bleManager: BLEManager(), isActive: .constant(false), isConnected: Binding.constant(true), isDelayed: true, baseColor: .green)
                .preferredColorScheme(.dark)
            SensorGrid(bleManager: BLEManager(), isActive: .constant(false))
                .preferredColorScheme(.dark)
            SensorGrid(bleManager: BLEManager(), isActive: .constant(false))
                .previewDevice("iPhone 8")
                .preferredColorScheme(.dark)
        }
    }
}



struct SensorViewSpeedandCadence: View {
    @ObservedObject var bleManager: BLEManager
    @Binding var isActive: Bool
    @Binding var isConnected: Bool
    @State var isDelayed: Bool = false
    let baseColor: Color
    var body: some View {
        GeometryReader { g in
            //            if isConnected {
            //                ZStack {
            //                    ZStack {
            //                        Rectangle()
            //                            .fill(LinearGradient(colors: [Color.green, Color.green, Color(hex: "D9D9D9").opacity(0)], startPoint: .bottom, endPoint: .top)
            //                            )
            //                            .frame(width: g.size.width)
            //                    }
            //                    .blur(radius: 45)
            //
            //                    Rectangle()
            //                        .fill(Color(hex: "1C1C1E").opacity(0.2))
            //
            //                    HStack {
            //                        Image(systemName: "speedometer")
            //                            .resizable()
            //                            .scaledToFit()
            //                            .frame(height: g.size.height * 40/100)
            //                            .foregroundColor(.green)
            //                            .shadow(color: .black.opacity(0.25), radius: 4, x: 0, y: 4)
            //
            //
            //                        Image("Crank")
            //                            .resizable()
            //                            .renderingMode(.template)
            //                            .foregroundColor(.green)
            //                            .scaledToFit()
            //                            .frame(height: g.size.height * 40/100)
            //                            .shadow(color: .black.opacity(0.25), radius: 4, x: 0, y: 4)
            //
            //
            //                    }
            //                }
            //                .frame(width: g.size.width, height: g.size.height)
            //            } else {
            //                ZStack {
            //                    Rectangle()
            //                        .frame(width: g.size.width, height: g.size.height)
            //                        .foregroundColor(Color(uiColor: .secondarySystemGroupedBackground))
            //
            //                    HStack {
            //                        Image(systemName: "speedometer")
            //                            .resizable()
            //                            .scaledToFit()
            //                            .frame(height: g.size.height * 40/100)
            //                            .foregroundColor(.white)
            //
            //
            //                        Image("Crank")
            //                            .resizable()
            //                            .renderingMode(.template)
            //                            .foregroundColor(.white)
            //                            .scaledToFit()
            //                            .frame(height: g.size.height * 40/100)
            //                    }
            //                }
            //                .frame(width: g.size.width, height: g.size.height)
            //                //                .onTapGesture {
            //                //                    isConnected.toggle()
            //                //                }
            //            }
            ZStack {
                Rectangle()
                    .fill(isDelayed ? LinearGradient(colors: [baseColor,baseColor,Color(hex: "D9D9D9").opacity(0)], startPoint: .bottom, endPoint: .top) : LinearGradient(colors: [Color(uiColor: .secondarySystemGroupedBackground)], startPoint: .center, endPoint: .center))
                    .frame(width: g.size.width, height: g.size.height)
                    .blur(radius: isDelayed ? 45 : 0)
                    .animation(.easeOut, value: isDelayed)
                    .onChange(of: isConnected) { newValue in
                        if !newValue {
                            isDelayed.toggle()
                        } else {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                isDelayed.toggle()
                            }
                        }
                        
                    }
                
                RoundedRectangle(cornerRadius: 20)
                    .stroke(lineWidth: 2)
                    .foregroundColor(baseColor)
                    .opacity(isConnected ? 1 : 0)
                    .animation(.linear(duration: 0.25).repeatCount(isConnected ? 5 : 0, autoreverses: true), value: isConnected)
                
                Rectangle()
                    .fill(Color(hex: "1C1C1E").opacity(isConnected ? 0.2 : 0))
                
                VStack {
                    HStack {
                        Image(systemName: "speedometer")
                            .resizable()
                            .scaledToFit()
                            .frame(height: g.size.height * 40/100)
                            .frame(maxWidth: isConnected ? .infinity : nil)
                            .foregroundColor(isConnected ? baseColor : .white)
                            .shadow(color: .black.opacity(0.25), radius: 4, x: 0, y: 4)
                            .animation(.easeOut.delay(isConnected ? 1.5 : 0), value: isConnected)
                            .scaleEffect(isConnected ? 0.5 : 1)
                            .animation(.easeOut.delay(isConnected ? 1.5 : 0), value: isConnected)
                        
                        Image("Crank")
                            .resizable()
                            .renderingMode(.template)
                            .scaledToFit()
                            .foregroundColor(isConnected ? baseColor : .white)
                            .frame(height: g.size.height * 40/100)
                            .frame(maxWidth: isConnected ? .infinity : nil)
                            .shadow(color: .black.opacity(0.25), radius: 4, x: 0, y: 4)
                            .animation(.easeOut.delay(isConnected ? 1.5 : 0), value: isConnected)
                            .scaleEffect(isConnected ? 0.5 : 1)
                            .animation(.easeOut.delay(isConnected ? 1.5 : 0), value: isConnected)
                        
                    }
                    
                    
                    if isConnected {
                        Spacer()
                    }
                }
                    
                    HStack {
                        VStack(spacing: 0) {
                            Spacer()
                            Text("\(bleManager.speedLabel)")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            Text("mph")
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundColor(.white.opacity(0.8))
                                .padding(.bottom,5)
                        }
                        .opacity(isConnected ? 1 : 0)
                        .animation(.easeOut.delay(isConnected ? 2.25 : 0), value: isConnected)
                        .frame(maxWidth: .infinity)
                        
                        VStack(spacing: 0) {
                            Spacer()
                            Text("\(bleManager.cadenceLabel)")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            Text("rpm")
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundColor(.white.opacity(0.8))
                                .padding(.bottom,5)
                        }
                        .opacity(isConnected ? 1 : 0)
                        .animation(.easeOut.delay(isConnected ? 2.25 : 0), value: isConnected)
                        .frame(maxWidth: .infinity)
                    }
                
            }
        }
        .frame(width: UIScreen.main.bounds.width * 180/428, height: UIScreen.main.bounds.height * 100/926)
        .cornerRadius(20)
        
        
    }
}


struct DefaultSensorView: View {
    @Binding var isActive: Bool
    @Binding var isConnected: Bool
    let sensorSystemImageName: String
    let baseColor: Color
    var body: some View {
        GeometryReader { g in
            if isConnected {
                ZStack {
                    ZStack {
                        Rectangle()
                            .fill(LinearGradient(colors: [baseColor,baseColor,Color(hex: "D9D9D9").opacity(0)], startPoint: .bottom, endPoint: .top))
                            .frame(width: g.size.width)
                    }
                    .blur(radius: 45)
                    Rectangle()
                        .fill(Color(hex: "1C1C1E").opacity(0.2))
                    
                    Image(systemName: sensorSystemImageName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: g.size.width * 50/180, height: g.size.height * 50/100)
                        .foregroundColor(baseColor)
                        .shadow(color: .black.opacity(0.25), radius: 4, x: 0, y: 4)
                        .frame(width: g.size.width, height: g.size.height)
                    
                    
                }
                .frame(width: g.size.width, height: g.size.height)
            } else {
                ZStack {
                    Rectangle()
                        .fill(isConnected ? Color(LinearGradient(colors: [baseColor,baseColor,Color(hex: "D9D9D9").opacity(0)], startPoint: .bottom, endPoint: .top) as! CGColor) : Color(uiColor: .secondarySystemGroupedBackground))
                        .frame(width: g.size.width, height: g.size.height)
                    Image(systemName: sensorSystemImageName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: g.size.width * 50/180, height: g.size.height * 50/100)
                        .foregroundColor(.white)
                }
                .frame(width: g.size.width, height: g.size.height)
                //                .onTapGesture {
                //                    isConnected.toggle()
                //                }
            }
        }
        .frame(width: UIScreen.main.bounds.width * 180/428, height: UIScreen.main.bounds.height * 100/926)
        .cornerRadius(20)
        
    }
}

struct LocationSensorView: View {
    @Binding var isActive: Bool
    @Binding var isConnected: Bool
    @State var isDelayed: Bool = false
    let sensorSystemImageName: String
    let baseColor: Color
    var body: some View {
        GeometryReader { g in
            ZStack {
                Rectangle()
                    .fill(isDelayed ? LinearGradient(colors: [baseColor,baseColor,Color(hex: "D9D9D9").opacity(0)], startPoint: .bottom, endPoint: .top) : LinearGradient(colors: [Color(uiColor: .secondarySystemGroupedBackground)], startPoint: .center, endPoint: .center))
                    .frame(width: g.size.width, height: g.size.height)
                    .blur(radius: isDelayed ? 45 : 0)
                    .animation(.easeOut, value: isDelayed)
                    .onChange(of: isConnected) { newValue in
                        if !newValue {
                            isDelayed.toggle()
                        } else {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                isDelayed.toggle()
                            }
                        }
                        
                    }
                
                RoundedRectangle(cornerRadius: 20)
                    .stroke(lineWidth: 2)
                    .foregroundColor(baseColor)
                    .opacity(isConnected ? 1 : 0)
                    .animation(.linear(duration: 0.25).repeatCount(isConnected ? 5 : 0, autoreverses: true), value: isConnected)
                
                Rectangle()
                    .fill(Color(hex: "1C1C1E").opacity(isConnected ? 0.2 : 0))
                
                VStack {
                    Image(systemName: sensorSystemImageName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: g.size.width * 50/180, height: g.size.height * 50/100)
                        .foregroundColor(isConnected ? baseColor : .white)
                        .shadow(color: .black.opacity(isConnected ? 0.25 : 0), radius: 4, x: 0, y: 4)
                        .animation(.easeOut.delay(isConnected ? 1.5 : 0), value: isConnected)
                    
                    
                }
                
                
            }
            .frame(width: g.size.width, height: g.size.height)
            
        }
        .frame(width: UIScreen.main.bounds.width * 180/428, height: UIScreen.main.bounds.height * 100/926)
        .cornerRadius(20)
    }
}


