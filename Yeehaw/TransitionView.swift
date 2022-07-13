//
//  TransitionView.swift
//  Yeehaw
//
//  Created by Yotzin Castrejon on 6/28/22.
//

import SwiftUI

struct TransitionView: View {
    @State var isPressed = false
    @State var isDelayed = false
    var body: some View {
        VStack {
            GeometryReader { g in
                ZStack {
                    Rectangle()
                        .fill(isDelayed ? LinearGradient(colors: [.red,.red,Color(hex: "D9D9D9").opacity(0)], startPoint: .bottom, endPoint: .top) : LinearGradient(colors: [Color(uiColor: .secondarySystemGroupedBackground)], startPoint: .center, endPoint: .center))
                        .frame(width: g.size.width, height: g.size.height)
                        .blur(radius: isDelayed ? 45 : 0)
                        .animation(.easeOut, value: isDelayed)
                        .onChange(of: isPressed) { newValue in
                            if !newValue {
                                isDelayed.toggle()
                            } else {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                    isDelayed.toggle()
                                }
                            }
                            
                        }
                    
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(lineWidth: 2)
                        .foregroundColor(.red)
                        .opacity(isPressed ? 1 : 0)
                        .animation(.linear(duration: 0.25).repeatCount(isPressed ? 5 : 0, autoreverses: true), value: isPressed)
                    
                    Rectangle()
                        .fill(Color(hex: "1C1C1E").opacity(isPressed ? 0.2 : 0))
                    
                    VStack {
                        Image(systemName: "heart.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: g.size.width * 50/180, height: g.size.height * 50/100)
                            .foregroundColor(isPressed ? .red : .white)
                            .shadow(color: .black.opacity(isPressed ? 0.25 : 0), radius: 4, x: 0, y: 4)
                            .animation(.easeOut.delay(isPressed ? 1.5 : 0), value: isPressed)
                            .scaleEffect(isPressed ? 0.5 : 1)
                            .animation(.easeOut.delay(isPressed ? 1.5 : 0), value: isPressed)
                        if isPressed {
                            Spacer()
                        }
                    }
                    
                    VStack(spacing: 0) {
                        Spacer()
                        Text("150")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        Text("bpm")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(.white.opacity(0.8))
                            .padding(.bottom,5)
                    }
                    .opacity(isPressed ? 1 : 0)
                    .animation(.easeOut.delay(isPressed ? 2.25 : 0), value: isPressed)
                    
                    
                    //                                .animation(.linear, value: isPressed)
                }
                .frame(width: g.size.width, height: g.size.height)
                //                .onTapGesture {
                //                    isConnected.toggle()
                //                }
                
            }
            .frame(width: UIScreen.main.bounds.width * 180/428, height: UIScreen.main.bounds.height * 100/926)
            .cornerRadius(20)
            Button {
                
                isPressed.toggle()
                
            } label: {
                Text("Button")
            }
            Spacer()
        }
        .animation(.spring(), value: isPressed)
        
    }
}


struct TransitionView_Previews: PreviewProvider {
    static var previews: some View {
        TransitionView()
            .preferredColorScheme(.dark)
    }
}

