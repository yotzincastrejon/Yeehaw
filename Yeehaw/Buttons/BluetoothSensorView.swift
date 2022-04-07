//
//  BluetoothSensorView.swift
//  Yeehaw
//
//  Created by Yotzin Castrejon on 3/17/21.
//

import SwiftUI

struct BluetoothSensorView: View {
    @State var icon: String
    @State var title: String
    @State var isConnected: Bool
    @State var isAnimating = false
    var body: some View {
        HStack(alignment: .center) {
            Image(systemName: icon)
                .padding(.leading,10)
            VStack(alignment: .leading) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.light)
                Text(isConnected ? "Connected" : "Searching...")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .opacity(isAnimating ? 0 : 1)
                    .animation(.linear(duration: 1.25).repeatForever(autoreverses: true), value: isAnimating)
            }
            .onAppear {
                if !isConnected {
                isAnimating = true
                }
            }
            Spacer()
        }
        .frame(maxWidth: 150, maxHeight: 60)
        .frame(minWidth: 150, minHeight: 60)
        .background(isConnected ? Color("Skyblue") : Color("BackgroundElevated"))
        .cornerRadius(10)
        
    }
}

struct BluetoothSensorView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            BluetoothSensorView(icon: "speedometer", title: "DuoTrap S", isConnected: false)
//            BluetoothSensorView(icon: "speedometer", title: "DuoTrap S", isConnected: true)
//                .preferredColorScheme(.dark)
        }
    }
}
