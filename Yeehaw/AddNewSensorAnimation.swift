//
//  AddNewSensorAnimation.swift
//  Yeehaw
//
//  Created by Yotzin Castrejon on 4/1/21.
//

import SwiftUI

struct AddNewSensorAnimation: View {
     @State var isAnimating = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Image(systemName: "antenna.radiowaves.left.and.right")
                    .font(.largeTitle)
                    .frame(width: 100, height: 100)
                Circle()
                    .stroke()
                    .scaleEffect(isAnimating ? 2 : 1)
                    .opacity(isAnimating ? 0 : 1)
                    .frame(width: geometry.size.width*0.25, height: geometry.size.height*0.25)
                    .animation(Animation.linear(duration: 1.25).repeatForever(autoreverses: false))
                    .overlay(
                        Circle()
                            .stroke()
                            .scaleEffect(isAnimating ? 2 : 1)
                            .opacity(isAnimating ? 0 : 1)
                            .frame(width: geometry.size.width*0.4, height: geometry.size.width*0.4)
                            .animation(Animation.linear(duration: 1.25).repeatForever(autoreverses: false))
                            .onAppear {
                                isAnimating = true
                            })
                VStack {
                    Spacer()
                    Text("Please hold the phone close to the sensors")
                }.padding(.bottom, 50)
            }
            .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
        }
    }
}

struct AddNewSensorAnimation_Previews: PreviewProvider {
    static var previews: some View {
        AddNewSensorAnimation()
    }
}
