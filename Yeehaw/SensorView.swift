//
//  SensorView.swift
//  Yeehaw
//
//  Created by Yotzin Castrejon on 6/27/22.
//

import SwiftUI

struct SensorView: View {
    @Binding var isActive: Bool
    @State var isConnected: Bool = false
    let sensorSystemImageName: String
    let baseColor: Color
    var body: some View {
        
        GeometryReader { g in
            if isConnected {
                ZStack {
                    ZStack {
                        Rectangle()
                            .fill(LinearGradient(colors: [baseColor,baseColor,Color(hex: "D9D9D9").opacity(0)], startPoint: .bottom, endPoint: .top))
                            .frame(width: g.size.width * 0.7)
                    }
                    .blur(radius: 40)
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
                        .frame(width: g.size.width, height: g.size.height)
                        .foregroundColor(Color(uiColor: .secondarySystemGroupedBackground))
                    Image(systemName: sensorSystemImageName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: g.size.width * 50/180, height: g.size.height * 50/100)
                        .foregroundColor(.white)
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

struct SensorView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SensorGrid(isActive: .constant(false))
                .preferredColorScheme(.dark)
            SensorGrid(isActive: .constant(false))
                .previewDevice("iPhone 8")
                .preferredColorScheme(.dark)
        }
    }
}

struct SensorViewSpeedandCadence: View {
    @Binding var isActive: Bool
    @State var isConnected = false
    var body: some View {
        GeometryReader { g in
            if isConnected {
                ZStack {
                    ZStack {
                        Rectangle()
                            .fill(LinearGradient(colors: [Color.green, Color.green, Color(hex: "D9D9D9").opacity(0)], startPoint: .bottom, endPoint: .top)
                            )
                            .frame(width: g.size.width * 0.7)
                    }
                    .blur(radius: 40)
                    
                    Rectangle()
                        .fill(Color(hex: "1C1C1E").opacity(0.2))
                    
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
                        .foregroundColor(Color(uiColor: .secondarySystemGroupedBackground))
                    
                    HStack {
                        Image(systemName: "speedometer")
                            .resizable()
                            .scaledToFit()
                            .frame(height: g.size.height * 40/100)
                            .foregroundColor(.white)
                        
                        
                        Image("Crank")
                            .resizable()
                            .renderingMode(.template)
                            .foregroundColor(.white)
                            .scaledToFit()
                            .frame(height: g.size.height * 40/100)
                    }
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


