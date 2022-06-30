//
//  TransitionView.swift
//  Yeehaw
//
//  Created by Yotzin Castrejon on 6/28/22.
//

import SwiftUI

struct TransitionView: View {
    @State var isPressed = false
    @Namespace var namespace
    var body: some View {
        VStack {
            if isPressed {
                Rectangle()
                    .fill(.black)
                    .matchedGeometryEffect(id: "Card1", in: namespace)
                    .frame(width: 200, height: 100)
                Rectangle()
                    .fill(.red)
                    .matchedGeometryEffect(id: "Card", in: namespace)
                    .frame(width: 200, height: 100)
                
                Spacer()
            } else {
                Spacer()
            Rectangle()
                    .fill(.red)
                    .matchedGeometryEffect(id: "Card", in: namespace, isSource: !isPressed)
                    .frame(width: 50, height: 100)
                    .transition(.opacity)
                Rectangle()
                    .fill(.black)
                    .matchedGeometryEffect(id: "Card1", in: namespace)
                    .frame(width: 100, height: 100)
            }
            Spacer()
            Button {
                // Do Seomthing
                withAnimation(.spring()) {
                isPressed.toggle()
                }
            } label: {
                Text("Press")
            }

            Button {
                // Do Seomthing
                
                isPressed.toggle()
                
            } label: {
                Text("Press")
            }
        }
    }
}

struct TransitionView_Previews: PreviewProvider {
    static var previews: some View {
        TransitionView()
    }
}
