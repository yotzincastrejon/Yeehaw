//
//  SensorGrid.swift
//  Yeehaw
//
//  Created by Yotzin Castrejon on 6/27/22.
//

import SwiftUI

struct SensorGrid: View {
    @Binding var isActive: Bool
    let columns = [GridItem(.flexible(), spacing: 20),GridItem(.flexible(), spacing: 20)]
    var body: some View {
            LazyVGrid(columns: columns, spacing: 20) {
                SensorView(isActive: $isActive, sensorSystemImageName: "heart.fill", baseColor: .red)
                    .opacity(isActive ? 0 : 1)
                    .offset(x: 0, y: isActive ? -100 : 0)
                    .animation(.easeOut.delay(isActive ? 0 : 1), value: isActive)
//                    .matchedGeometryEffect(id: "Heart Rate", in: mainView, isSource: !isActive)
                SensorViewSpeedandCadence(isActive: $isActive)
                    .opacity(isActive ? 0 : 1)
                    .offset(x: 0, y: isActive ? -100 : 0)
                    .animation(.easeOut.delay(isActive ? 0 : 1), value: isActive)
                SensorView(isActive: $isActive, sensorSystemImageName: "bolt.fill", baseColor: .yellow)
                    .opacity(isActive ? 0 : 1)
                    .offset(x:isActive ? -100 : 0, y: 0)
                    .animation(.easeOut.delay(isActive ? 0 : 1), value: isActive)
                SensorView(isActive: $isActive, sensorSystemImageName: "location.fill", baseColor: .blue)
                    .opacity(isActive ? 0 : 1)
                    .offset(x: isActive ? 100 : 0, y: 0)
                    .animation(.easeOut.delay(isActive ? 0 : 1), value: isActive)
            }
            .padding(20)
    }
}

struct SensorGrid_Previews: PreviewProvider {
    @Namespace static var namespace
    static var previews: some View {
        SensorGrid(isActive: .constant(false))
            .preferredColorScheme(.dark)
    }
}
