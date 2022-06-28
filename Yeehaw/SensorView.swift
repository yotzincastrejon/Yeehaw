//
//  SensorView.swift
//  Yeehaw
//
//  Created by Yotzin Castrejon on 6/27/22.
//

import SwiftUI

struct SensorView: View {
    @State var isConnected = true
    let sensorSystemImageName: String
    let baseColor: Color
    var body: some View {
        VStack {
            VStack {
                GeometryReader { g in
                    if isConnected {
                        ZStack {
                            Rectangle()
                                .fill(LinearGradient(colors: [baseColor,baseColor.opacity(0.5),Color(hex: "D9D9D9").opacity(0)], startPoint: .bottom, endPoint: .top))
                                .frame(width: g.size.width * 0.65)
                            Rectangle()
                                .fill(LinearGradient(colors: [baseColor,.clear], startPoint: .bottom, endPoint: .center))
                                .frame(width: g.size.width * 0.65)
                                .blendMode(.screen)
                                
                            Image(systemName: sensorSystemImageName)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 50, height: 50)
                                .foregroundColor(baseColor)
                                .shadow(color: .black.opacity(0.25), radius: 4, x: 0, y: 4)
                                .frame(width: g.size.width, height: g.size.height)
                                .background(
                                    .bar
                                )
                        }
                        .frame(width: g.size.width, height: g.size.height)
                    } else {
                        ZStack {
                            Rectangle()
                                .frame(width: g.size.width, height: g.size.height)
                                .cornerRadius(20)
                                .foregroundColor(Color(uiColor: .secondarySystemGroupedBackground))
                            Image(systemName: sensorSystemImageName)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 50, height: 50)
                        }
                        .frame(width: g.size.width, height: g.size.height)
                        .onTapGesture {
                            isConnected.toggle()
                        }
                    }
                }
            }
            .frame(width: 180, height: 100)
        .cornerRadius(20)
            
        }
    }
}

//struct SensorView_Previews: PreviewProvider {
//    static var previews: some View {
//        SensorView(sensorSystemImageName: "heart.fill", baseColor: .red)
//            .preferredColorScheme(.dark)
//    }
//}

struct SensorViewSpeedandCadence: View {
    @State var isConnected = true
    var body: some View {
        VStack {
            VStack {
                GeometryReader { g in
                    if isConnected {
                        ZStack {
                            Rectangle()
                                .fill(LinearGradient(colors: [.green,.green.opacity(0.5),Color(hex: "D9D9D9").opacity(0)], startPoint: .bottom, endPoint: .top))
                                .frame(width: g.size.width * 0.65)
                            Rectangle()
                                .fill(LinearGradient(colors: [.green,.clear], startPoint: .bottom, endPoint: .center))
                                .frame(width: g.size.width * 0.65)
                                .blendMode(.screen)
                            Rectangle()
                                .fill(.clear)
                                .background(.bar)
                                
                            HStack {
                                Image(systemName: "speedometer")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 40)
                                    .foregroundColor(.green)
                                .shadow(color: .black.opacity(0.25), radius: 4, x: 0, y: 4)
                              
                                
                                Image("Crank")
                                    .scaledToFit()
                                    .offset(x: 0, y: 4)
                                    .frame(height: 40)
                                    .shadow(color: .black.opacity(0.25), radius: 4, x: 0, y: 4)
                               
                                    
                            }
                        }
                        .frame(width: g.size.width, height: g.size.height)
                    } else {
                        ZStack {
                            Rectangle()
                                .frame(width: g.size.width, height: g.size.height)
                                .cornerRadius(20)
                                .foregroundColor(Color(uiColor: .secondarySystemGroupedBackground))
                            Image(systemName: "speedometer")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 50, height: 40)
                        }
                        .frame(width: g.size.width, height: g.size.height)
                        .onTapGesture {
                            isConnected.toggle()
                        }
                    }
                }
            }
            .frame(width: 180, height: 100)
        .cornerRadius(20)
            
        }
    }
}


