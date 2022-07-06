//
//  TransitionView.swift
//  Yeehaw
//
//  Created by Yotzin Castrejon on 6/28/22.
//

import SwiftUI

struct TransitionView: View {
    @State var isPressed = false
    var body: some View {
        VStack {
            ZStack {
                //View that is shown after the button is pressed.
                Rectangle()
                    .frame(width: 50, height: 50)
                    .offset(x: isPressed ? 0 : 300, y: 0)
                    .opacity(isPressed ? 1 : 0)
                    .animation(.spring().delay(isPressed ? 1 : 0), value: isPressed)

                // Default View is Shown
                Rectangle()
                    .fill(.red)
                     .frame(width: 50, height: 50)
                     .opacity(isPressed ? 0 : 1)
                     .offset(x: isPressed ? -100 : 0, y: 0)
                     .animation(.spring().delay(isPressed ? 0 : 1), value: isPressed)
                     
            }
            Button(action: {
                withAnimation {
                    isPressed.toggle()
                }
            }) {
                Text("Press")
            }
         
        }
    }
}

struct TransitionView_Previews: PreviewProvider {
    static var previews: some View {
        TransitionView()
        ShowOne()
    }
}

struct ShowOne: View {
    @State var showOne = true
    var body: some View {
        VStack {
                    if showOne {
                        HStack {
                            Spacer()
                            Text("One")
                            Spacer()
                        }
                        .background(Color.red)
                        .id("one")
//                        .animation(Animation.default)
                        .transition(.slide)
                    } else {
                        HStack {
                            Spacer()
                            Text("Two")
                            Spacer()
                        }
                        .background(Color.blue)
                        .id("two")
//                        .animation(Animation.default.delay(2))
                        .transition(.slide)
                    }
                    Button("Toggle") {
                        withAnimation {
                            self.showOne.toggle()
                        }
                    }
                }
    }
}
