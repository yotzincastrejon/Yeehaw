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
                                .frame(width: g.size.width * 50/180, height: g.size.height * 50/100)
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
                                .frame(width: g.size.width * 50/180, height: g.size.height * 50/100)
                                .foregroundColor(.white)
                        }
                        .frame(width: g.size.width, height: g.size.height)
                    }
            }
            .frame(width: UIScreen.main.bounds.width * 180/428, height: UIScreen.main.bounds.height * 100/926)
        .cornerRadius(20)
           
        
        
        
    }
}

struct SensorView_Previews: PreviewProvider {
    static var previews: some View {
        //        SensorView(sensorSystemImageName: "heart.fill", baseColor: .red)
        //            .preferredColorScheme(.dark)
        //        SensorViewSpeedandCadence()
        //            .preferredColorScheme(.dark)
        Group {
            SensorGrid()
                .preferredColorScheme(.dark)
            SensorGrid()
                .previewDevice("iPhone 8")
                .preferredColorScheme(.dark)
        }
    }
}

struct SensorViewSpeedandCadence: View {
    @State var isConnected = true
    var body: some View {
       
           
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
                                    .frame(height: g.size.height * 40/100)
                                    .foregroundColor(.green)
                                    .shadow(color: .black.opacity(0.25), radius: 4, x: 0, y: 4)
                                
                                
                                Image("Crank")
                                    .resizable()
                                    .renderingMode(.template)
                                    .foregroundColor(.green)
                                    .scaledToFit()
                                    .frame(height: g.size.height * 40/100)
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
                .frame(width: UIScreen.main.bounds.width * 180/428, height: UIScreen.main.bounds.height * 100/926)
            .cornerRadius(20)
            
        
    }
}


