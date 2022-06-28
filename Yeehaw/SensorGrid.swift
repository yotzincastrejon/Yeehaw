//
//  SensorGrid.swift
//  Yeehaw
//
//  Created by Yotzin Castrejon on 6/27/22.
//

import SwiftUI

struct SensorGrid: View {
    let columns = [GridItem(.flexible(), spacing: 20),GridItem(.flexible(), spacing: 20)]
    var body: some View {
            LazyVGrid(columns: columns, spacing: 20) {
                SensorView(sensorSystemImageName: "heart.fill", baseColor: .red)
                SensorView(sensorSystemImageName: "bolt.fill", baseColor: .yellow)
                SensorView(sensorSystemImageName: "location.fill", baseColor: .blue)
                SensorViewSpeedandCadence()
            }
            .padding(20)
    }
}

struct SensorGrid_Previews: PreviewProvider {
    static var previews: some View {
        SensorGrid()
            .preferredColorScheme(.dark)
    }
}
