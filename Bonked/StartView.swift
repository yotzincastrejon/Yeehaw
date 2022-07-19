//
//  StartView.swift
//  Yeehaw
//
//  Created by Yotzin Castrejon on 6/28/22.
//

import SwiftUI

struct StartView: View {
    @ObservedObject var locationHelper: LocationHelper
    @Binding var isActive: Bool
    var body: some View {
        GeometryReader { g in
            ZStack {
//                Rectangle()
//                    .fill(LinearGradient(colors: [Color(hex: "FF5400"), Color(hex: "00B4D8")], startPoint: .topLeading, endPoint: .bottomTrailing))
//                    .frame(height: g.size.height)
//                Rectangle()
//                    .fill(Color(hex: "201D23").opacity(0.30))
//                    .background(.ultraThinMaterial)
//                    .frame(height: g.size.height)
                
                
                HStack {
                    Spacer()
                    GoalsButton(image: Image("medal"), height: 33)
                        .frame(width: 52, height: 52)
                    Spacer()
                    GoButton(locationHelper: locationHelper, isActive: $isActive)
                        .frame(width: 100, height: 100)
                    Spacer()
                    SettingsButton(image: Image(systemName: "gearshape"), height: 27)
                        .frame(width: 52, height: 52)
                    Spacer()
                }
            }
            .frame(width: g.size.width, height: g.size.height)
        }
        .frame(height: UIScreen.main.bounds.height * 180/926)
        .cornerRadius(20)
    }
}

struct StartView_Previews: PreviewProvider {
    @Namespace static var namespace
    static var previews: some View {
        StartView(locationHelper: LocationHelper(), isActive: .constant(true))
            .preferredColorScheme(.dark)
    }
}


struct GoButton: View {
    @ObservedObject var locationHelper: LocationHelper
    @Binding var isActive: Bool
    var body: some View {
        Button(action:  {
            // Do Something
            locationHelper.startTracking()
            withAnimation(.spring()) {
            isActive.toggle()
            }
        }) {
            GeometryReader { g in
                ZStack {
                    Circle()
                        .fill(LinearGradient(colors: [Color(hex: "FF5400"), Color(hex: "FF6D00")], startPoint: .bottom, endPoint: .top))
                    VStack(spacing: 0) {
                        Image("Bike")
                        Text("GO")
                            .font(.system(size: g.size.height * 34/100, weight: .bold))
                            .foregroundColor(.white)
                    }
                }
            }
        }
    }
}


struct SettingsButton: View {
    let image: Image
    let height: CGFloat
    @State var isShowing = false
    var body: some View {
        Button(action: {
            // Do Something
            isShowing.toggle()
        }) {
            ZStack {
                Circle()
                    .fill(Color(hex: "FFE7BF"))
                image
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(Color(hex: "FF5400"))
                    .frame(height: height)
            }
        }
        .sheet(isPresented: $isShowing) {
            EmptyView()
        }
    }
}

struct GoalsButton: View {
    let image: Image
    let height: CGFloat
    @State var isShowing = false
    var body: some View {
        Button(action: {
            // Do Something
            isShowing.toggle()
        }) {
            ZStack {
                Circle()
                    .fill(Color(hex: "FFE7BF"))
                image
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(Color(hex: "FF5400"))
                    .frame(height: height)
            }
        }
        .sheet(isPresented: $isShowing) {
            EmptyView()
        }
    }
}
