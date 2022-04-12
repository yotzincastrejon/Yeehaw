//
//  RSSISignalStrength.swift
//  Yeehaw
//
//  Created by Yotzin Castrejon on 4/7/22.
//

import SwiftUI

struct RSSISignalStrength: View {
    @State var rssiSignal: Int
    let width: CGFloat = 4
    let height: CGFloat = 20
    let primaryColor: Color = .green
    @State var fillArray = [false, false, false, false, false]
    var body: some View {
        HStack(alignment: .bottom, spacing: 2) {
            Capsule()
                .fill(fillArray[0] ? primaryColor : .gray)
                .frame(width: width, height: height * 0.2)
            Capsule()
                .fill(fillArray[1] ? primaryColor : .gray)
                .frame(width: width, height: height * 0.4)
            Capsule()
                .fill(fillArray[2] ? primaryColor : .gray)
                .frame(width: width, height: height * 0.6)
            Capsule()
                .fill(fillArray[3] ? primaryColor : .gray)
                .frame(width: width, height: height * 0.8)
            Capsule()
                .fill(fillArray[4] ? primaryColor : .gray)
                .frame(width: width, height: height)
        }
        .onAppear() {
            signalStrengthCalculation()
        }
    }
    
    func signalStrengthCalculation() {
        switch rssiSignal {
            case -65 ..< 0:
                fillArray = [true, true, true, true, true]
            case -75 ..< -65:
                fillArray = [true, true, true, true, false]
            case -85 ..< -75:
                fillArray = [true, true, true, false, false]
            case -95 ..< -85:
                fillArray = [true, true, false, false, false]
            case -105 ..< -95:
                fillArray = [true, false, false, false, false]
            default:
                fillArray = [false, false, false, false, false]
        }
    }
}

struct RSSISignalStrength_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color(#colorLiteral(red: 0.1254901961, green: 0.1254901961, blue: 0.1254901961, alpha: 1))
        RSSISignalStrength(rssiSignal: -80)
            
        }
    }
}
