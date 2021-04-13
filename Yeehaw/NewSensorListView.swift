//
//  NewSensorListView.swift
//  Yeehaw
//
//  Created by Yotzin Castrejon on 3/30/21.
//

import SwiftUI

struct NewSensorListView: View {
    @State var name: String
    @State var isConnected: Bool
    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: "heart")
            VStack(alignment: .leading) {
                Text(name)
                    .fontWeight(.bold)
                Text(isConnected ? "Connected" : "Searching...")
            }
            Spacer()
        }
        .padding(.leading)
        .frame(minWidth: 150, idealWidth: .infinity, maxWidth: .infinity, minHeight: 100, idealHeight: 100, maxHeight: 100)
        .background(Color("Background"))
    }
}

struct NewSensorListView_Previews: PreviewProvider {
    static var previews: some View {
        NewSensorListView(name: "Duo Trap S", isConnected: true)
            .preferredColorScheme(.dark)
    }
}
