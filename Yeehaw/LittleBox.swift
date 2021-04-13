//
//  LittleBox.swift
//  Yeehaw
//
//  Created by Yotzin Castrejon on 4/7/21.
//

import SwiftUI

struct LittleBox: View {
    @ObservedObject var wheelupdated: BLEManager
    var body: some View {
        VStack {
            if wheelupdated.wheelupdated > 4 {
                Circle()
                    .frame(minWidth: 10, maxWidth: 10, minHeight: 10, maxHeight: 10)
                    .foregroundColor(.green)
                    
            }
            if wheelupdated.wheelupdated <= 4 {
                Circle()
                    .frame(minWidth: 10, maxWidth: 10, minHeight: 10, maxHeight: 10)
                    .foregroundColor(.red)
                    
        }
    }
}
}

struct LittleBox_Previews: PreviewProvider {
    static var previews: some View {
        LittleBox(wheelupdated: BLEManager())
    }
}
