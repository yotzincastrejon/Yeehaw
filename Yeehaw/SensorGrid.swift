//
//  SensorGrid.swift
//  Yeehaw
//
//  Created by Yotzin Castrejon on 6/27/22.
//

import SwiftUI

struct SensorGrid: View {
    var body: some View {
        VStack {
            SensorView(sensorSystemImageName: "heart.fill", baseColor: .red)
            SensorView(sensorSystemImageName: "bolt.fill", baseColor: .yellow)
            SensorView(sensorSystemImageName: "location.fill", baseColor: .blue)
            
        }
    }
}

struct SensorGrid_Previews: PreviewProvider {
    static var previews: some View {
        SensorGrid()
            .preferredColorScheme(.dark)
    }
}
